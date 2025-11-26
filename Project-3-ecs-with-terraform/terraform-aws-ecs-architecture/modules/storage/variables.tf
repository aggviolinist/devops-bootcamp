# Main details
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
}