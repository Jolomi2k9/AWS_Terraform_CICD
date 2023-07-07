# --- autoscaling/main.tf ---

resource "aws_autoscaling_group" "app-asg" {
  name                      = "app-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_type         = "ELB"
  desired_capacity          = var.asg_desired_capacity
  force_delete              = true
  launch_configuration      = aws_launch_configuration.app-launch-config.name
  vpc_zone_identifier       = var.asg_vpc_zone_identifier
  target_group_arns         = toset([var.lb_target_group_arn])
}

resource "aws_launch_configuration" "app-launch-config" {
  name = "app-launch-config"
  image_id      = var.linux2_ami
  instance_type = var.instance_type
  security_groups = [var.webapp_sg]
  key_name = var.key_name
}

resource "aws_autoscaling_attachment" "autoscaling-attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.id
  lb_target_group_arn   = var.lb_target_group_arn
}