output "ecr_repo" {
  value = aws_ecr_repository.nest_app_repo.repository_url
}