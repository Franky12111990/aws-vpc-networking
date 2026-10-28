variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "subnet_cidrs" {
  description = "CIDR blocks for VPC subnets"

  type = object({
    public_a  = string
    public_b  = string
    private_a = string
    private_b = string
  })
}
variable "availability_zones" {
  description = "Availability Zones for network subnets"

  type = object({
    a = string
    b = string
  })
}
