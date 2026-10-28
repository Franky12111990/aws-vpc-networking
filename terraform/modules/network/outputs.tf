output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Subnet IDs indexed by subnet name"

  value = {
    for name, subnet in aws_subnet.this :
    name => subnet.id
  }
}
