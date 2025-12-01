module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  internet_cidr        = var.internet_cidr

}

module "security" {
  source        = "./modules/security"
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  vpc_id        = module.network.vpc_id
  internet_cidr = var.internet_cidr

}

module "management" {
  source       = "./modules/management"
  project_name = var.project_name

}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
  bucket_name  = var.bucket_name
}

module "instances" {
  source               = "./modules/instances"
  project_name         = var.project_name
  private_subnet_ids   = module.network.private_subnet_ids
  instance_type        = var.instance_type
  ec2_instance_profile = module.management.ec2_instance_profile
  eice_ssh_sg_id       = module.security.eice_ssh_sg_id
  container_sg_id      = module.security.container_sg_id
}

module "database" {
  source             = "./modules/database"
  project_name       = var.project_name
  db_name            = var.db_name
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version
  db_username        = var.db_username
  database_sg_id     = module.security.database_sg_id
  private_subnet_ids = module.network.private_subnet_ids
}

module "containers" {
  source                  = "./modules/containers"
  project_name            = var.project_name
  private_subnet_ids      = module.network.private_subnet_ids
  container_sg_id         = module.security.container_sg_id
  alb_target_group        = module.traffic.alb_target_group
  ecs_task_role           = module.management.ecs_task_role
  ecs_task_execution_role = module.management.ecs_task_execution_role
  database_secret_arn     = module.database.database_secret_arn
  database_endpoint       = module.database.database_endpoint
  ecr_repo                = module.registry.ecr_repo
  database_name           = module.database.database_name
  alb_dns_name            = module.traffic.alb_dns_name
}

module "traffic" {
  source            = "./modules/traffic"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  alb_server_sg_id  = module.security.alb_server_sg_id
  public_subnet_ids = module.network.public_subnet_ids
}

module "registry" {
  source       = "./modules/registry"
  project_name = var.project_name
}