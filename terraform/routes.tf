resource "aws_internet_gateway" "main" {
  vpc_id = module.network.vpc_id

  tags = {
    Name = "terraform-devops-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.network.vpc_id

  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = module.network.public_a_subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = module.network.public_b_subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = module.network.vpc_id

  tags = {
    Name = "terraform-private-rt"
  }
}
resource "aws_route_table_association" "private_a" {
  subnet_id      = module.network.private_a_subnet_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = module.network.private_b_subnet_id
  route_table_id = aws_route_table.private.id
}
