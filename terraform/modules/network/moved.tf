moved {
  from = aws_subnet.public_a
  to   = aws_subnet.this["public_a"]
}

moved {
  from = aws_subnet.public_b
  to   = aws_subnet.this["public_b"]
}

moved {
  from = aws_subnet.private_a
  to   = aws_subnet.this["private_a"]
}

moved {
  from = aws_subnet.private_b
  to   = aws_subnet.this["private_b"]
}
