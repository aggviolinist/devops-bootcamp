output "ec2instance_instance_profile" {
    value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ecs_task_role_secrets_manager" {
    value = aws_iam_role.custom_role_for_ecs_task_secrets_manager.name
}

output "ecs_task_execution_role_secrets_manager" {
    value = aws_iam_role.custom_role_for_ecs_task_execution_secrets_manager.name
}