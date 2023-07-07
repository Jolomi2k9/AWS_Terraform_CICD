# --- compute/output.tf ---

output "jenkins_public_ip" {  
  description = "Jenkins instance pub ip"
  value       = aws_instance.jenkins.public_ip
}

output "key_pair" {
  value = aws_key_pair.tr_auth.id
}