#alb security group
resource "aws_security_group" "alb_server_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow Inbound HTTP/HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr]
  }
  egress {
    description = "Allow Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]

  }

  tags = {
    Name = "${var.project_name}-alb-server-sg"
  }
}

#ssh security group
resource "aws_security_group" "eice_ssh_sg" {
  name        = "${var.project_name}-ssh-sg"
  description = "Allow SSH traffic to our EC2 instance to manage database traansfer etc"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.project_name}-eice-ssh-sg"
  }
}

#container security group
resource "aws_security_group" "container_sg" {
  name        = "${var.project_name}-container-sg"
  description = "Allow Inbound and Outbound traffic to our ECS containers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow inbound traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_server_sg.id]
  }

  ingress {
    description     = "Allow inbound traffic from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_server_sg.id]
  }

  ingress {
    description     = "Allow inbound traffic from SSH SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eice_ssh_sg.id]
  }
  egress {
    description = "Allow Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.project_name}-container-sg"
  }
}

#database security group
resource "aws_security_group" "database_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow Inbound traffic from container security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Inbound MYSQL traffic from container SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.container_sg.id]
  }
  egress {
    description = "Allow Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.project_name}-database-sg"
  }
}