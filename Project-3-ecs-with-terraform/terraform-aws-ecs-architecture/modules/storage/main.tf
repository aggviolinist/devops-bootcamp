resource "aws_s3_bucket" "ecs_s3_bucket" {
    bucket = var.bucket_name

    tags = {
        Name = "${var.project_name}-ecs-bucket"
    }
}