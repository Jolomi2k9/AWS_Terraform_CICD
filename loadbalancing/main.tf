# --- loadbalancing/main.tf ---

resource "aws_lb" "alb" {
  name               = "loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.loadbalancer_sg]
  subnets            = var.public_subnets
  idle_timeout = 400

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "prod-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  #ignore changes to name of target group
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
  health_check {
    healthy_threshold   = var.alb_healthy_threshold
    unhealthy_threshold = var.alb_unhealthy_threshold
    timeout             = var.alb_timeout
    interval            = var.alb_interval
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arnawsiam:187416307283server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}