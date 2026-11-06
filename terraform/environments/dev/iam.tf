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
resource "aws_iam_role_policy" "private_ec2_s3_read" {
  name = "terraform-dev-private-ec2-s3-read"
  role = aws_iam_role.private_ec2.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.app_data.arn}/hello.txt"
      }
    ]
  })
}
