resource "aws_lb" "roboshop_web_alb" {
  name               = "${local.name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  tags = merge(
    var.common_tags,
    {
        Name = "web_alb"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.roboshop_web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn    = data.aws_ssm_parameter.aws_acm_arm.value
  
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, I am a fixed responsef from web_alb"
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
      name    = "web-alb-${var.environment}"
      type    = "A"
      alias   = {
        name    = "${aws_lb.roboshop_web_alb.dns_name}" #ALB dns Name
        zone_id = aws_lb.roboshop_web_alb.zone_id
      }
    }
  ]
}