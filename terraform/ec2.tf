data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/noble/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  subnet_id                   = module.network.public_a_subnet_id
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true

  key_name = "alex-devops-key"

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "terraform-bastion"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

resource "aws_instance" "private" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  subnet_id                   = module.network.private_a_subnet_id
  vpc_security_group_ids      = [aws_security_group.private.id]
  associate_public_ip_address = false

  key_name = "alex-devops-key"

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "terraform-private-ec2"
  }
}
