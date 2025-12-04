output "alb_server_sg_id" {
  value = aws_security_group.alb_server_sg.id
}

output "eice_ssh_sg_id" {
  value = aws_security_group.eice_ssh_sg.id
}

output "container_sg_id" {
  value = aws_security_group.container_sg.id
}

output "database_sg_id" {
  value = aws_security_group.database_sg.id
}