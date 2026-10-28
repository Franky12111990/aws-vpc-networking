variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR, for example 10.20.0.0/16."
  }
}
variable "subnet_cidrs" {
  description = "CIDR blocks for VPC subnets"

  type = object({
    public_a  = string
    public_b  = string
    private_a = string
    private_b = string
  })
  validation {
    condition = alltrue([
      for cidr in var.subnet_cidrs : can(cidrnetmask(cidr))
    ])
    error_message = "All subnet_cidrs values must be valid IPv4 CIDR blocks."
  }
}
variable "availability_zones" {
  description = "Availability Zones for network subnets"

  type = object({
    a = string
    b = string
  })
}
variable "subnets" {
  description = "Subnet settings indexed by subnet name"

  type = map(object({
    cidr   = string
    az     = string
    public = bool
  }))

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(cidrnetmask(subnet.cidr))
    ])

    error_message = "Every subnet must have a valid IPv4 CIDR."
  }
}
