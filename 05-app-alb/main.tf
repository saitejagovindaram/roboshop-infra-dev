resource "aws_lb" "roboshop_app_alb" {
  name               = "${local.name}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = local.subnets

  tags = merge(
    var.common_tags,
    {
        Name = "app_alb"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.roboshop_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, I am a fixed response"
      status_code  = "200"
    }
  }
}

#creating route53 records
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "*.app-alb-${var.environment}"
      type    = "A"
      alias   = {
        name    = "${aws_lb.roboshop_app_alb.dns_name}" #ALB dns Name
        zone_id = aws_lb.roboshop_app_alb.zone_id
      }
    }
  ]
}