locals {
  name = "${var.project_name}-${var.environment}"
  subnets = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
}