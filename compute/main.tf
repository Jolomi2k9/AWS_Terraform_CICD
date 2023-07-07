# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


resource "random_id" "tr_instance_id" {
  byte_length = 2
  count       = var.instance_count
  #forces random id to also replaced when instances are replaced
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "tr_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins" {
  #count         = var.instance_count
  instance_type = var.instance_type 
  ami           = var.linux2_ami

  tags = {
    Name = "jenkins"
  }

  key_name               = aws_key_pair.tr_auth.id
  vpc_security_group_ids = [var.jenkins_sg]
  subnet_id              = var.public_subnets[1]
  user_data              = file(var.jenkins_path)  
}

resource "aws_instance" "ansible" {
  #count         = var.instance_count
  instance_type = var.instance_type
  ami           = var.linux2_ami

  tags = {
    Name = "ansible"
  }

  key_name               = aws_key_pair.tr_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[1]
  user_data              = file(var.ansible_path)  
}

resource "aws_instance" "sonarqube" {
  #count         = var.instance_count
  instance_type = var.instance_type_2 
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "sonarqube"
  }

  key_name               = aws_key_pair.tr_auth.id
  vpc_security_group_ids = [var.sonarqube_sg]
  subnet_id              = var.public_subnets[1]    
}

resource "aws_instance" "grafana" {
  #count         = var.instance_count
  instance_type = var.instance_type 
  ami           = var.linux2_ami

  tags = {
    Name = "grafana"
  }

  key_name               = aws_key_pair.tr_auth.id
  vpc_security_group_ids = [var.grafana_sg]
  subnet_id              = var.public_subnets[1]
  user_data              = file(var.grafana_path)  
}



