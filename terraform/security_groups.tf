resource "aws_security_group" "public" {
  name        = "terraform-public-sg"
  description = "Security group for public EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "terraform-public-sg"
  }
}

resource "aws_security_group" "private" {
  name        = "terraform-private-sg"
  description = "Security group for private EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "terraform-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.public.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "public_to_private_ssh" {
  security_group_id            = aws_security_group.public.id
  referenced_security_group_id = aws_security_group.private.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}
resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  security_group_id = aws_security_group.public.id

  cidr_ipv4 = var.ssh_allowed_cidr
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  description = "Allow SSH from my public IP"
}
resource "aws_vpc_security_group_egress_rule" "public_http" {
  security_group_id = aws_security_group.public.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  description = "Allow outbound HTTP"
}
resource "aws_vpc_security_group_egress_rule" "public_https" {
  security_group_id = aws_security_group.public.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  description = "Allow outbound HTTPS"
}
