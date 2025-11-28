output "database_name" {
  value = aws_db_instance.ecs_tier_rds_database.db_name
}
output "database_secret_arn" {
  sensitive = true
  value = aws_secretsmanager_secret.ecs_rds_secret.arn
}
output "database_endpoint" {
  sensitive = true
  value = aws_db_instance.ecs_tier_rds_database.endpoint
}