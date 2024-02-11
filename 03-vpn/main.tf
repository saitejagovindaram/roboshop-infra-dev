module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name = "${var.project_name}-vpn"

  instance_type          = "t2.small"
#   key_name               = "user1" # we are not using any key pair
#   monitoring             = true
  user_data = file("openvpnsetup.sh")
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg.value]
  subnet_id              = data.aws_subnet.default.id

  tags = merge(
    var.common_tags,
    {
        Name = "vpn"
    }
  )
}