
locals {
  vpc_cidr = "10.0.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = var.ssh_port
          to          = var.ssh_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        https = {
          from        = var.https_port
          to          = var.https_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }        
      }
    }

    jenkins = {
      name        = "jenkins_sg"
      description = "Allow ports 8080"
      ingress = {
        jenkins = {
          from        = var.jenkins_port
          to          = var.jenkins_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    sonarqube = {
      name        = "sonarqube_sg"
      description = "Allow ports 9000"
      ingress = {
        sonarqube = {
          from        = var.sonarqube_port
          to          = var.sonarqube_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    grafana = {
      name        = "grafana_sg"
      description = "Allow ports 3000"
      ingress = {
        grafana = {
          from        = var.grafana_port
          to          = var.grafana_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    loadbalancer = {
      name        = "alb_sg"
      description = "Allow ports 80"
      ingress = {
        http = {
          from        = var.http_port
          to          = var.http_port
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }        
      }
    }
    webapp = {
      name        = "webapp_sg"
      description = "Allow connections only from loadbalancer"
      ingress = {
        http = {
          from        = var.http_port
          to          = var.http_port
          protocol    = "tcp"
          # security_groups = [aws_security_group.alb_sg.id]          
          cidr_blocks = [var.access_ip]
        }        
      }
    }
  }
}