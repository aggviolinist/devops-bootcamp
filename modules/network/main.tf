data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}
#VPC
resource "aws_vpc" "container_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#Subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.container_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    tier = "alb & nat"
  }

  depends_on = [aws_vpc.container_vpc]

}
resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.container_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    tier = count.index < 2 ? "app" : "db"
  }

  depends_on = [aws_vpc.container_vpc]
}
#IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.container_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.container_vpc.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}

#Route Table Associations
resource "aws_route_table_association" "public_route_table_association" {
  count = var.public_subnet_count

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
#NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
  depends_on = [aws_eip.nat_eip]
}
#Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.container_vpc.id

  route {
    cidr_block     = var.internet_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
  depends_on = [aws_nat_gateway.nat_gateway]
}

#Private Route Table Associations
resource "aws_route_table_association" "private_route_table_association" {
  count = var.private_subnet_count

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}