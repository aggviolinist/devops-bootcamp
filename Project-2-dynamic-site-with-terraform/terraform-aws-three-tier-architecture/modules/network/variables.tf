# Main details
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

# Network
variable "vpc_cidr" {
  description = "VPC CIDR value"
  type        = string
}