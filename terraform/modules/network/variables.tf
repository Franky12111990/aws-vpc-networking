variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR, for example 10.20.0.0/16."
  }
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
