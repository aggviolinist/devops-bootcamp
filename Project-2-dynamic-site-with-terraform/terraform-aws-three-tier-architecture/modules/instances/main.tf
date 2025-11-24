#eice
resource "aws_ec2_instance_connect_endpoint" "eice_connect_endpoint" {
  subnet_id          = var.private_subnets[1] #Second app private subnet
  security_group_ids = [var.eice_sg_id]

  tags = {
    Name = "${var.project_name}-eice"
  }
}

#ec2instance
resource "aws_instance" "web_server_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.web_server_sg_id]
  subnet_id              = var.private_subnets[0] #first app private subnet
  iam_instance_profile   = var.ec2instance_three_tier_instance_profile

  tags = {
    Name = "${var.project_name}-web-server-instance"
  }
}

