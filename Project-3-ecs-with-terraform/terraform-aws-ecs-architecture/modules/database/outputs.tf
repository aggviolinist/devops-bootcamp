output "database_name" {
  value = aws_db_instance.ecs_tier_rds_database.db_name
}
output "database_username" {
  sensitive = true
  value = var.aws_db_instance.ecs_tier_rds_database.arn
}
output "database_password" {
  sensitive = true
  value = random_password.ecs_create_db_password.result
}
output "database_endpoint" {
  sensitive = true
  value = aws_db_instance.ecs_tier_rds_database.endpoint
}