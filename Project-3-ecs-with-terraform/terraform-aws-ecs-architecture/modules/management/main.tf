#Policy to give EC2 tasks access to s3
resource "aws_iam_policy" "custom_policy_for_s3" {
    name = "ec2-policy-s3"
    description = "Policy to give EC2 tasks access s3"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket",
                    "s3:ListAllMyBuckets"
                ]
                Resource = "*"
            }
        ]
    })
}

#Policy to give EC2 and ECS access to secrets manager
resource "aws_iam_policy" "custom_policy_for_secrets_manager" {
    name = "ec2-and-ecs-policy-secrets-manager"
    description = "Policy to give EC2 and ECS tasks access to secrets manager"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]
                Resource = "*"
            }
        ]
    })
}
#Role to give EC2 tasks access to s3 and secrets manager
resource "aws_iam_role" "custom_role_for_ec2_s3_secrets_manager" {
    name = "ec2-role-for-s3-secrets-manager"
    description = "Role to give ECS tasks access to secrets manager and s3"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

#Role for ECS TASK ROLE to secrets manager
resource "aws_iam_role" "custom_role_for_ecs_secrets_manager" {
    name = "ecs-role-for-secrets-manager"
    description = "Role to give ECS tasks access to secrets manager"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

#Role for ECS TASK ROLE to secrets manager


resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_ec2_role" {
    role = aws_iam_role.custom_role_for_ec2_s3_secrets_manager.name
    policy_arn = aws_iam_policy.custom_policy_for_s3.arn
}
resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy_to_ec2_role" {
    role = aws_iam_role.custom_role_for_ec2_s3_secrets_manager.name
    policy_arn = aws_iam_policy.custom_policy_for_secrets_manager.arn
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "${var.project_name}-ec2-profile"
    role = aws_iam_role.custom_role_for_ec2_s3_secrets_manager.name
}

resource "aws_iam_role_policy_attachment" "attach_secret_manager_policy_to_ecs_role" {
    role = aws_iam_role.custom_role_for_ecs_secrets_manager.name
    policy_arn = aws_iam_policy.custom_policy_for_secrets_manager.arn
}