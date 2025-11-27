variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "db_name" {
  description = "The name of the database to be created"
  type        = string
}
variable "instance_class" {
  description = "The instance class for the database"
  type        = string
}
variable "engine" {
  description = "The database engine to use"
  type        = string
}
variable "engine_version" {
  description = "The version of the database engine"
  type        = string
}
variable "db_username" {
  description = "The master username for the database"
  type        = string
}
variable "database_sg_id" {
  description = "Security Group ID for the database"
  type        = string
}