# Creating security group and its rules for VPN
module "vpn" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for vpn"
  environment = var.environment
  component = "vpn"
  vpc_id = data.aws_vpc.default.id
  common_tags = var.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "vpn" {
  security_group_id = module.vpn.sg_id
  cidr_ipv4   = "0.0.0.0/0"
  # from_port   = 0
  ip_protocol = -1 # -1 represents allow all traffic
  # to_port     = 65535
  # referenced_security_group_id = module.catalogue.sg_id
}

# Creating security group MONGODB
module "mongodb" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for mongodb"
  environment = var.environment
  component = "mongodb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}
# Creating security group REDIS
module "redis" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for redis"
  environment = var.environment
  component = "redis"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}
# Creating security group MYSQL
module "mysql" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for mysql"
  environment = var.environment
  component = "mysql"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}
# Creating security group RABBITMQ
module "rabbitmq" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for rabbitmq"
  environment = var.environment
  component = "rabbitmq"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group CATALOGUE
module "catalogue" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for catalouge"
  environment = var.environment
  component = "catalogue"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group CART
module "cart" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for cart"
  environment = var.environment
  component = "cart"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group USER
module "user" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for user"
  environment = var.environment
  component = "user"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group SHIPPING
module "shipping" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for shipping"
  environment = var.environment
  component = "shipping"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group PAYMENTS
module "payments" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for payments"
  environment = var.environment
  component = "payments"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group WEB
module "web" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for web"
  environment = var.environment
  component = "web"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

# Creating security group app-alb
module "app_alb" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for app_alb"
  environment = var.environment
  component = "app_alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}
# Creating security group web-alb
module "web_alb" {
  source = "git::https://github.com/saitejagovindaram/terraform-aws_security_group.git"
  # source = "../../terraform-aws_security_group"

  project_name = var.project_name
  description = "This security group is for web_alb"
  environment = var.environment
  component = "web_alb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

#Creating rules for mongodb that allow traffic from catalogue on port 27017
resource "aws_vpc_security_group_ingress_rule" "mongodb-catalogue" {
  security_group_id = module.mongodb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 27017
  to_port     = 27017
  ip_protocol = "tcp"
  referenced_security_group_id = module.catalogue.sg_id
}

#Creating rules for mongodb that allow traffic from user on port 27017
resource "aws_vpc_security_group_ingress_rule" "mongodb-user" {
  security_group_id = module.mongodb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 27017
  to_port     = 27017
  ip_protocol = "tcp"
  referenced_security_group_id = module.user.sg_id
}

#Creating rules for mongodb that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "mongodb-vpn" {
  security_group_id = module.mongodb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}



#Creating rules for redis that allow traffic from user on port 6379
resource "aws_vpc_security_group_ingress_rule" "redis-cart" {
  security_group_id = module.redis.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
  referenced_security_group_id = module.cart.sg_id
}

#Creating rules for redis that allow traffic from user on port 6379
resource "aws_vpc_security_group_ingress_rule" "redis-user" {
  security_group_id = module.redis.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
  referenced_security_group_id = module.user.sg_id
}

#Creating rules for redis that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "redis-vpn" {
  security_group_id = module.redis.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for mysql that allow traffic from shipping on port 3306
resource "aws_vpc_security_group_ingress_rule" "mysql-shipping" {
  security_group_id = module.mysql.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
  referenced_security_group_id = module.shipping.sg_id
}

#Creating rules for mysql that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "mysql-vpn" {
  security_group_id = module.mysql.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for rabbitmq that allow traffic from payments on port 5672
resource "aws_vpc_security_group_ingress_rule" "rabbitmq-payments" {
  security_group_id = module.rabbitmq.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5672
  to_port     = 5672
  ip_protocol = "tcp"
  referenced_security_group_id = module.payments.sg_id
}

#Creating rules for rabbitmq that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "rabbitmq-vpn" {
  security_group_id = module.rabbitmq.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#############################################################################

#Creating rules for web_alb that allow traffic from internet on port 80
resource "aws_vpc_security_group_ingress_rule" "web_alb-internet" {
  security_group_id = module.web_alb.sg_id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  # referenced_security_group_id = module.web_alb.sg_id
}

#Creating rules for app_alb that allow traffic from web on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-web" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.web.sg_id
}

#Creating rules for app_alb that allow traffic from vpn on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-vpn" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for app_alb that allow traffic from catalogue on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-catalogue" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.catalogue.sg_id
}

#Creating rules for app_alb that allow traffic from user on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-user" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.user.sg_id
}

#Creating rules for app_alb that allow traffic from user on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-cart" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.cart.sg_id
}

#Creating rules for app_alb that allow traffic from shipping on port 80
resource "aws_vpc_security_group_ingress_rule" "app_alb-shipping" {
  security_group_id = module.app_alb.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.shipping.sg_id
}


#############################################################################

#Creating rules for web that allow traffic from web_alb on port 80
resource "aws_vpc_security_group_ingress_rule" "web-web_alb" {
  security_group_id = module.web.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = module.web_alb.sg_id
}

#Creating rules for web that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "web-vpn" {
  security_group_id = module.web.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for catalogue that allow traffic from VPN on port 8080
resource "aws_vpc_security_group_ingress_rule" "catalogue-app_alb" {
  security_group_id = module.catalogue.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = module.app_alb.sg_id
}

#Creating rules for catalogue that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "catalogue-vpn" {
  security_group_id = module.catalogue.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for user that allow traffic from app_alb on port 8080
resource "aws_vpc_security_group_ingress_rule" "user-app_alb" {
  security_group_id = module.user.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = module.app_alb.sg_id
}

#Creating rules for user that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "user-vpn" {
  security_group_id = module.user.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for cart that allow traffic from app_alb on port 8080
resource "aws_vpc_security_group_ingress_rule" "cart-app_alb" {
  security_group_id = module.cart.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = module.app_alb.sg_id
}

#Creating rules for user that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "cart-vpn" {
  security_group_id = module.cart.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}

#Creating rules for shipping that allow traffic from app_alb on port 8080
resource "aws_vpc_security_group_ingress_rule" "shipping-app_alb" {
  security_group_id = module.shipping.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = module.app_alb.sg_id
}

#Creating rules for shipping that allow traffic from VPN on port 22
resource "aws_vpc_security_group_ingress_rule" "shipping-vpn" {
  security_group_id = module.shipping.sg_id
  # cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = module.vpn.sg_id
}




