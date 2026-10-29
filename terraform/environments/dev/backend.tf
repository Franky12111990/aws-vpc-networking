terraform {
  backend "s3" {
    bucket       = "alex-tfstate-852982060240-us-east-1"
    key          = "terraform/aws-vpc-networking.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
