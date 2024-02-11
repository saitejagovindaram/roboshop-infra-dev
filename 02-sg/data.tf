data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

data "aws_vpc" "default" {
  default = true
}

# data "aws_subnet" "defaultvpc" {
#   vpc_id = data.aws_vpc.default.id
#   availability_zone = "us-east-1a"
# }

