output "vpc_id" {
  value = aws_vpc.container_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_name" {
  value = aws_vpc.container_vpc.tags["Name"]
}

output "private_subnet" {
  value = aws_subnet.private_subnet
}
output "public_subnet" {
  value = aws_subnet.public_subnet
}
