output "ec2_instance_name" {
  value = aws_instance.ecs_instance.tags["Name"]
}
output "ec2_instance_endpoint" {
  value = aws_ec2_instance_connect_endpoint.ecs_instance_connect_endpoint.tags["Name"]
}