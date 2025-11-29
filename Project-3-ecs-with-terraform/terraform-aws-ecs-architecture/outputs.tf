#Outputs
##VPC name
output "vpc_name" {
  value = module.network.vpc_name
}

##Public subnets
output "private_subnet_name_and_tiers" {
  value = {
    for s in module.network.public_subnet :
    s.tags.Name => s.tags.tier
  }
}

##Private subnets
output "private_subnet_names_and_tiers" {
  value = {
    for s in module.network.private_subnet :
    s.tags.Name => s.tags.tier
  }
}

#Instance
output "ec2_instance_name" {
  value = module.instances.ec2_instance_name
}
output "ec2_instance_endpoint" {
  value = module.instances.ec2_instance_endpoint
}

#Storage
output "s3_bucket_name" {
  value = module.storage.project_bucket
}

#Database
output "database_name" {
  value = module.database.database_name
}

#ECS
output "container" {
  value = module.containers.container_name
}
