module "mongodb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-${var.environment}-mongodb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-mongodb"
    }
  )
}

resource "null_resource" "mongodb-null" {
  triggers = {
    trigger = module.mongodb.id
  }

  connection {
    host = module.mongodb.private_ip
    user = "centos"
    password = "DevOps321"
    type = "ssh"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }  

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb dev",
    ]
  }
}

module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-${var.environment}-mysql"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "ec2RoleSaiteja"

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-mysql"
    }
  )
}

resource "null_resource" "mysql-null" {
  triggers = {
    trigger = module.mysql.id
  }

  connection {
    host = module.mysql.private_ip
    user = "centos"
    password = "DevOps321"
    type = "ssh"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }  

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev",
    ]
  }
}

module "redis" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-${var.environment}-mysql"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-redis"
    }
  )
}

resource "null_resource" "redis-null" {
  triggers = {
    trigger = module.redis.id
  }

  connection {
    host = module.redis.private_ip
    user = "centos"
    password = "DevOps321"
    type = "ssh"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }  

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis dev",
    ]
  }
}

module "rabbitmq" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-${var.environment}-rabbitmq"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "ec2RoleSaiteja"

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-rabbitmq"
    }
  )
}

resource "null_resource" "rabbitmq-null" {
  triggers = {
    trigger = module.rabbitmq.id
  }

  connection {
    host = module.rabbitmq.private_ip
    user = "centos"
    password = "DevOps321"
    type = "ssh"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }  

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq dev",
    ]
  }
}

#creating route53 records
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "mongodb-${var.environment}"
      type    = "A"
      ttl     = 1
      records = [
        "${module.mongodb.private_ip}"
      ]
    },
     {
      name    = "redis-${var.environment}"
      type    = "A"
      ttl     = 1
      records = [
        "${module.redis.private_ip}"
      ]
    },
     {
      name    = "mysql-${var.environment}"
      type    = "A"
      ttl     = 1
      records = [
        "${module.mysql.private_ip}"
      ]
    },
    {
      name    = "rabbitmq-${var.environment}"
      type    = "A"
      ttl     = 1
      records = [
        "${module.rabbitmq.private_ip}"
      ]
    },
  ]
}