locals {
  subnets = {
    public_a = {
      cidr   = var.subnet_cidrs.public_a
      az     = var.availability_zones.a
      public = true
    }

    public_b = {
      cidr   = var.subnet_cidrs.public_b
      az     = var.availability_zones.b
      public = true
    }

    private_a = {
      cidr   = var.subnet_cidrs.private_a
      az     = var.availability_zones.a
      public = false
    }

    private_b = {
      cidr   = var.subnet_cidrs.private_b
      az     = var.availability_zones.b
      public = false
    }
  }
}

resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "terraform-${replace(each.key, "_", "-")}"
  }
}
