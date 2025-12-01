resource "aws_alb_target_group" "ecs_three_tier_target_group" {
  name        = "${var.project_name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/" # Adjust to your health check endpoint
    matcher             = "200,302"
  }

  tags = {
    Name = "${var.project_name}-target-group"
  }
  depends_on = [aws_alb.ecs_three_tier_elb]
}

resource "aws_alb" "ecs_three_tier_elb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_server_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_alb_listener" "ecs_three_tier_listener" {
  load_balancer_arn = aws_alb.ecs_three_tier_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_three_tier_target_group.arn
  }
}