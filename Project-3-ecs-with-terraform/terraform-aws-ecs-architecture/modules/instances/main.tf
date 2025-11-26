#ec2instanceendpoint to connect to ec2 instances
resource "aws_ec2_instance_connect_endpoint" "ecs_instance_connect_endpoint" {
    subnet_id = var.private_subnet_ids[1]
    security_group_ids = var.eice_ssh_sg_id

    tags = {
        Name = "${var.project_name}-ecs-eice"
    }
}

data "aws_ami" "ecs_tier_ami" {
    most_recent = true
    owners      = ["amazon"]
     filter {
        name  = "name"
        values = ["al2023-ami-ecs-hvm-*-x86_64"]
     }
     filter {
        name = "virtualization-type"
        values = ["hvm"]
     }
     filter {
        state = "available"
     }

}

#ec2instances for ECS cluster
resource "aws_instance" "ecs_instance" {
    ami = data.aws_ami.ecs_tier_ami.id
    instance_type = var.instance_type
    subnet_id = var.private_subnet_ids[0]
    vpc_security_group_ids = var.container_sg_id
    iam_instance_profile = var.ec2instance_instance_profile

    tags = {
        Name = "${var.project_name}-ec2"
    }
}