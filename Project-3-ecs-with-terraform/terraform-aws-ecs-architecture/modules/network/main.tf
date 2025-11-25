#VPC
resource "aws_vpc" "container_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-vpc"
    }
}

#Subnet
resource "aws_subnet" "public_subnet" {
    count = var.public_subnet_count
    
}

resource "aws_subnet" "private_subnet" {
    count = var.private_subnet_count
}