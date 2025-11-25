module "network" {
    source = "./modules/network"
    project_name = var.project_name
    vpc_cidr = var.vpc_cidr
    public_subnet_count = var.public_subnet_count
    private_subnet_count = var.private_subnet_count
}

module "security" {
    source = "./modules/security"
    project_name = var.project_name
    vpc_cidr = var.vpc_cidr
    vpc_id = module.network.vpc_id
    
}