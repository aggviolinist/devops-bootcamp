resource "aws_alb_target_group" "three_tier_target_group_alb" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/" # Adjust to your health check endpoint
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-target-group"
  }
}

resource "aws_alb" "three_tier_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = "dev"
  }
}

resource "aws_alb_listener" "three_tier_listener" {
  load_balancer_arn = aws_alb.three_tier_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.three_tier_target_group_alb.arn
  }
}