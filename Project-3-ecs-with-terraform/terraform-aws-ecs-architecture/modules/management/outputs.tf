output "ec2_instance_profile" {
  value = aws_iam_instance_profile.custom_role_for_ec2_policies.name 
}


output "ecs_task_role" {
  value = aws_iam_role.custom_role_for_ecs_task_policies.name
}

output "ecs_task_execution_role" {
  value = aws_iam_role.custom_role_for_ecs_task_execution_policies.name
}