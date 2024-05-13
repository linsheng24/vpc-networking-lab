output "left_public_ec2_public_ip" {
  value = module.left_public_ec2.public_ip
}

output "left_public_ec2_private_ip" {
  value = module.left_public_ec2.private_ip
}

output "right_public_ec2_public_ip" {
  value = module.right_public_ec2.public_ip
}

output "right_public_ec2_private_ip" {
  value = module.right_public_ec2.private_ip
}

output "left_private_ec2_private_ip" {
  value = module.left_private_ec2.private_ip
}

output "key_name" {
  value = "${var.key_pair_name}.pem"
}

output "left_ssh_connection" {
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${module.left_public_ec2.public_ip}"
  description = "SSH connection command for the left VPC instance"
}

output "right_ssh_connection" {
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${module.right_public_ec2.public_ip}"
  description = "SSH connection command for the right VPC instance"
}

output "left_private_ssh_connection" {
  value       = "ssh -i ${var.key_pair_name}.pem -o ProxyCommand='ssh -W %h:%p -i ${var.key_pair_name}.pem ubuntu@${module.left_public_ec2.public_ip}' ubuntu@${module.left_private_ec2.private_ip}"
  description = "SSH connection command for the left private VPC instance via Bastion Host"
}

output "load_balancer_endpoint" {
  value = aws_lb.alb.dns_name
}

output "myip" {
  value = chomp(data.http.myip.response_body)
}
