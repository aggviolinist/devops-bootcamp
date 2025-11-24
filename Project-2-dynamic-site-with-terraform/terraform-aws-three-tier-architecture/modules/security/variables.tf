# Main details
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

# Network
variable "vpc_cidr" {
  description = "The VPC Cidr"
  type        = string
}
variable "vpc_id" {
  description = "The VPC ID on our module"
  type        = string
}