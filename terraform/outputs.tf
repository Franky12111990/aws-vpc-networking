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
  value       = module.network.vpc_id
}
output "subnet_ids" {
  description = "Subnet IDs from the network module"
  value       = module.network.subnet_ids
}
