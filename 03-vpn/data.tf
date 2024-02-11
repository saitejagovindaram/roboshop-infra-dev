data "aws_ami" "centos8" {
  most_recent      = true  # based on created date
  owners = [ "973714476881" ]

  filter {
    name   = "name"
    values = ["*Centos-8*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.vpc.id
  availability_zone = "us-east-1a"
}

data "aws_ssm_parameter" "vpn_sg" {
  name = "/${var.project_name}/${var.environment}/vpn_sg_id"
}