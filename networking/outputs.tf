# --- networking/output.tf ---

output "vpc_id" {
  value = aws_vpc.production_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}

output "public_sg" {
  value = aws_security_group.sg["public"].id
}

output "jenkins_sg" {
  value = aws_security_group.sg["jenkins"].id
}

output "sonarqube_sg" {
  value = aws_security_group.sg["sonarqube"].id
}

output "grafana_sg" {
  value = aws_security_group.sg["grafana"].id
}

output "alb_sg" {
  value = aws_security_group.sg["loadbalancer"].id
}

output "webapp_sg" {
  value = aws_security_group.sg["webapp"].id
}


