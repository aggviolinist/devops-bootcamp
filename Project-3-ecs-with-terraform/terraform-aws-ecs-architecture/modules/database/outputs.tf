output "database-name" {
  value = aws_db_instance.ecs_tier_rds_database.tags["Name"]
}