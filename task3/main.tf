
provider "aws" {
  access_key = "" # insert your access_key here
  secret_key = "" # insert your secret_key here  
  region     = "us-east-1"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "moodle_server_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.moodle_sg.id]
  key_name               = aws_key_pair.moodle_key.key_name
  user_data              = file("data_moodle.sh")

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }

  tags = {
    Name  = "Moodle WebServer build by Terraform"
    Owner = "Sparrow"
  }
}

resource "aws_key_pair" "for_moodle_key" {
  key_name   = "for-moodle-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

resource "aws_security_group" "moodle_sg" {
  name        = "Moodle WebServer Security Group"
  description = "Moodle Security Group with Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.moodle_server_instance.public_ip
}