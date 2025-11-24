data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}
#VPC
resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % 2)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

#Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = 4
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index % 2)

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    tier = count.index < 2 ? "app" : "db"
  }
}

#IGW
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#RouteTable
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}
#Associate our public subnets to the public route table
resource "aws_route_table_association" "public_assoc" {
  count = 2

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


#Elastic Ip
resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-elastic-ip"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat-eip.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
  depends_on = [aws_eip.nat-eip]
}

# Private Route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

# Associate our private subnet to Nat Gateway
resource "aws_route_table_association" "private_assoc" {
  count = 4

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


