variable "project_name" {
    description = "Name of the project for resource tagging"
    type = string
}

variable "vpc_cidr" {
    description = "VPC CIDR value"
    type = string
}

variable "public_subnet_count" {
    description = "Number of public subnets to create"
    type = number
}

variable "private_subnet_count" {
    description = "Number of private subnets to create"
    type = number
}

variable "internet_cidr" {
    description = "CIDR block for internet access"
    type = string
}