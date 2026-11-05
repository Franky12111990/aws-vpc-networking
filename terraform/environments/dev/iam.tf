resource "aws_iam_role" "private_ec2" {
  name = "terraform-dev-private-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_instance_profile" "private_ec2" {
  name = "terraform-dev-private-ec2"
  role = aws_iam_role.private_ec2.name
}
