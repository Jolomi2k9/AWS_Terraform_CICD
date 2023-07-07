# --- autoscaling/variables.tf ---

variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "lb_target_group_arn" {}
variable "asg_vpc_zone_identifier" {}
variable "linux2_ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "webapp_sg" {}