module "user" {
  source = "../../roboshop-app-tf-module"

  ami_id = data.aws_ami.centos8.id
  component = "user"
  environment = "dev"
  project_name = "roboshop"
  component_sg_id = data.aws_ssm_parameter.user_sg_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  app_alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  role_priority = 11
}