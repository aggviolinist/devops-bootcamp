module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  vpc_id       = module.network.vpc_id

}

module "instace" {
  source = "./modules/instances"

  project_name                            = var.project_name
  private_subnets                         = module.network.private_subnets
  eice_sg_id                              = module.security.eice_sg_id
  ami                                     = var.ami
  instance_type                           = var.instance_type
  web_server_sg_id                        = module.security.web_server_sg_id
  ec2instance_three_tier_instance_profile = module.management.ec2instance_three_tier_instance_profile

}

module "management" {
  source       = "./modules/management"
  project_name = var.project_name
}


module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
}

module "database" {
  source          = "./modules/database"
  project_name    = var.project_name
  private_subnets = module.network.private_subnets
  instance_class  = var.instance_class
  db_name         = var.db_name
  engine          = var.engine
  engine_version  = var.engine_version
  db_username     = var.db_username
  rds_sg_id       = module.security.rds_sg_id
}

module "scaling" {
  source                                  = "./modules/scaling"
  project_name                            = var.project_name
  ami                                     = var.ami
  instance_type                           = var.instance_type
  web_server_sg_id                        = module.security.web_server_sg_id
  ec2instance_three_tier_instance_profile = module.management.ec2instance_three_tier_instance_profile
  private_subnets                         = module.network.private_subnets
  alb_target_group                        = module.traffic.alb_target_group
}

module "monitoring" {
  source                        = "./modules/monitoring"
  project_name                  = var.project_name
  scale_up_autoscaling_policy   = module.scaling.scale_up_autoscaling_policy
  scale_down_autoscaling_policy = module.scaling.scale_down_autoscaling_policy
  three_tier_asg                = module.scaling.three_tier_asg
}

module "traffic" {
  source         = "./modules/traffic"
  project_name   = var.project_name
  vpc_id         = module.network.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.network.public_subnets
}