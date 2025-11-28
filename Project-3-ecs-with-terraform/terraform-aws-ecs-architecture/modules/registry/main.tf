# Create ECR repository
resource "aws_ecr_repository" "nest_app_repo" {
  name                 = "${var.project_name}-nest-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}

# Lifecycle policy to keep repo clean (delete old images)
resource "aws_ecr_lifecycle_policy" "nest_app_repo_lifecycle" {
  repository = aws_ecr_repository.nest_app_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
