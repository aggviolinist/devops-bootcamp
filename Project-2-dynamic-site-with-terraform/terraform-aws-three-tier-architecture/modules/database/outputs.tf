output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.three_tier_rds_database.endpoint
}

output "rds_secret_arn" {
  description = "Arn of the secret"
  value       = aws_secretsmanager_secret.rds_secret.arn
}