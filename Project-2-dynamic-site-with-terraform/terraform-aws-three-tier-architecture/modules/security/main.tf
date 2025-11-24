#alb
resource "aws_security_group" "alb_server_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow Traffic from net to our server"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow All Outbound rules"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

#ssh
resource "aws_security_group" "eice_ssh_sg" {
  name        = "${var.project_name}-ssh-sg"
  description = "Allow SSH traffic to Web Server"
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

#web-server
resource "aws_security_group" "web_server_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow Inbound and Outbound HTTP/HTTPS to our Web Server"
  vpc_id      = var.vpc_id

  ingress {

    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eice_ssh_sg.id]
  }
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_server_sg.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_server_sg.id]
  }
  egress {
    description = "Allow All Outbound rules"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-server-sg"
  }
}

#database
resource "aws_security_group" "database-sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow SQL traffic only from my Web server"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MYSQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }
  egress {
    description = "Allow Traffic out of network"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-rds-sg"
  }

}