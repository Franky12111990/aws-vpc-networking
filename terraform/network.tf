module "network" {
  source   = "./modules/network"
  vpc_cidr = "10.20.0.0/16"
}

moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}
moved {
  from = aws_subnet.public_a
  to   = module.network.aws_subnet.public_a
}

moved {
  from = aws_subnet.public_b
  to   = module.network.aws_subnet.public_b
}

moved {
  from = aws_subnet.private_a
  to   = module.network.aws_subnet.private_a
}

moved {
  from = aws_subnet.private_b
  to   = module.network.aws_subnet.private_b
}
