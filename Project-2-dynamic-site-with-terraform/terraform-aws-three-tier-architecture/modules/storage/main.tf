resource "aws_s3_bucket" "nest_dev_bucket" {
  bucket = "nest-dev-obako"

  tags = {
    Name = "${var.project_name}-bucket"
  }
}