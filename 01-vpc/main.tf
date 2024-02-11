module "roboshop-vpc" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_vpc.git"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  environment = var.environment
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  isPeeringRequired = var.isPeeringRequired
  common_tags = var.common_tags
}