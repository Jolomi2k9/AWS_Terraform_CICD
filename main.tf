# --- root/main.tf ---

module "networking" {
  source   = "./networking"
  vpc_cidr = local.vpc_cidr
  #number of subnet to generate
  private_sn_count = 2
  public_sn_count  = 2
  max_subnets      = 20
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  #for loop to generate subnet numbers using cidrsubnet function
  private_cidrs = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  public_cidrs  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "loadbalancing" {
  source                  = "./loadbalancing"
  loadbalancer_sg         = module.networking.alb_sg
  public_subnets          = module.networking.public_subnets
  tg_port                 = var.http_port
  tg_protocol             = "HTTP"
  vpc_id                  = module.networking.vpc_id
  alb_healthy_threshold   = 2
  alb_unhealthy_threshold = 2
  alb_timeout             = 3
  alb_interval            = 30
  listener_port           = var.http_port
  listener_protocol       = "HTTP"
}

module "compute" {
  source         = "./compute"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  jenkins_sg      = module.networking.jenkins_sg
  sonarqube_sg      = module.networking.sonarqube_sg
  grafana_sg      = module.networking.grafana_sg
  instance_count = 1
  instance_type  = "t2.micro"
  instance_type_2  = "t2.small"
  vol_size       = "10"
  public_key_path = "~/.ssh/trkey.pub"
  key_name        = "trkey"
  jenkins_path    = "jenkins_install.sh"
  ansible_path    = "ansible_install.sh"
  grafana_path    = "grafana_install.sh"
  linux2_ami      = "ami-09f6caae59175ba13"
}

module "ecr" {
  source         = "./ecr"
  repo_name = "docker_repository"
}

module "autoscaling" {
  source         = "./autoscaling"
  asg_max_size = 2
  asg_min_size = 1
  asg_desired_capacity = 2
  lb_target_group_arn = module.loadbalancing.tg_arn
  asg_vpc_zone_identifier = module.networking.private_subnets
  linux2_ami      = "ami-09f6caae59175ba13"
  instance_type = "t2.micro"
  key_name = module.compute.key_pair
  webapp_sg      = module.networking.webapp_sg
}