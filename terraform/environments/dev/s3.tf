resource "aws_s3_bucket" "app_data" {
  bucket        = "alex-devops-dev-app-data-852982060240-us-east-1"
  force_destroy = false

  tags = {
    Name        = "terraform-dev-app-data"
    Environment = "dev"
  }
}
resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_object" "access_check" {
  bucket       = aws_s3_bucket.app_data.id
  key          = "hello.txt"
  content      = "Private EC2 S3 access check.\n"
  content_type = "text/plain"
}
