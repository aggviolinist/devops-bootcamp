variable "project_name" {
    description = "Name of the project for resource tagging"
    type = string
}

variable "vpc_id" {
    description = "The VPC ID of our project"
    type = string
}

variable "vpc_cidr" {
    description = "The CIDR block of our VPC"
    type = string
}

variable "internet_cidr" {
    description = "CIDR block for internet access"
    type = string
}