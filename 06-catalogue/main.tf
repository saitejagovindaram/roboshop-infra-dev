/*  1. create instance
    2. provision with ansible or shell
    3. stop the instance 
    4. take AMI 
    5. delete instance
    6. create launch template with ami
    7. create Target group
    8. create auto scaling group
 */

# create instance
module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-catalogue-ami"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(local.subnet_ids, 0)

  tags = merge(
    var.common_tags,
    {
        Name = "catalogue"
    }
  )
}

# provision with ansible or shell
resource "null_resource" "catalogue" {
  triggers = {
    instance_id = module.catalogue.id
  }

  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev"
    ]
  }
}

#stop the instance
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}

# take AMI
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project_name}-catalogue-ami-${local.current_time}"
  source_instance_id = module.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}

# delete instance
resource "null_resource" "catalogue_terminate" {
  
  triggers = {
    instance_id = aws_ami_from_instance.catalogue.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
  }

  depends_on = [ aws_ami_from_instance.catalogue ]
}

# create launch template with ami
resource "aws_launch_template" "catalogue_template" {
    name = "${var.project_name}-catalogue-template"

    image_id = aws_ami_from_instance.catalogue.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value] 
    instance_initiated_shutdown_behavior = "terminate" 

    tag_specifications {
    resource_type = "instance"

    tags = {
        Name = "${var.project_name}-catalogue-${var.environment}"
      }
    }
}

# create Target group
resource "aws_lb_target_group" "catalogue_tg" {
  name        = "${var.project_name}-catalogue-tg"
  target_type = "instance" #default is instance
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 60
  health_check {
    path = "/health"
    port = 8080
    healthy_threshold = 3
    interval = 10
    timeout = 5
    unhealthy_threshold = 2
    matcher =  "200-299"
  }
}

# create auto scaling group
resource "aws_autoscaling_group" "catalogue_asg" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  health_check_grace_period = 60
  health_check_type = "ELB"
  vpc_zone_identifier = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns = [ aws_lb_target_group.catalogue_tg.arn ]

  launch_template {
    id      = aws_launch_template.catalogue_template.id
    version = aws_launch_template.catalogue_template.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-catalogue"
    propagate_at_launch = true
  }

}

# create autoscaling policy
resource "aws_autoscaling_policy" "catalogue_targetTrackingPolicy" {
  name = "${var.project_name}-${var.environment}-asg_policy"
  autoscaling_group_name = aws_autoscaling_group.catalogue_asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75
  }
}

# create load balancer listener rule
resource "aws_lb_listener_rule" "catalogue_LBlistenerRule" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue_tg.arn
  }

  condition {
    host_header {
      values = ["catalogue.app-alb-${var.environment}.saitejag.site"]
    }
  }
}