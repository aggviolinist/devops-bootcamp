#Main details
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

#Network
variable "vpc_cidr" {
  description = "VPC CIDR value"
  type        = string
}
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
}
variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
}
variable "internet_cidr" {
  description = "CIDR block for internet access"
  type        = string
}

#S3 Bucket
variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
}


#EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type for container instances"
  type        = string
}
