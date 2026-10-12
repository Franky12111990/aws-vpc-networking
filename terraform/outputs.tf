output "bastion_public_ip" {
  description = "Public IP of Bastion"
  value       = aws_instance.bastion.public_ip
}

output "private_ec2_ip" {
  description = "Private IP of EC2"
  value       = aws_instance.private.private_ip
}

output "vpc_id" {
  description = "VPC identifier"
  value       = aws_vpc.main.id
}
