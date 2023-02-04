
provider "aws" {
  access_key = "" # insert your access_key here
  secret_key = "" # insert your secret_key here  
  region     = "us-east-1"
}

resource "aws_instance" "jenkins_server_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.jenkinskey.key_name
  user_data              = file("jenkins.sh")

  tags = {
    Name  = "Jenkins WebServer build by Terraform"
    Owner = "Sparrow"
  }
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "jenkinskey" {
  key_name   = "jenkinskey"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "jenkinskey.pem"
}


resource "aws_security_group" "jenkins_sg" {
  name = "Jenkins Sequrity Group"

  dynamic "ingress" {
    for_each = ["22", "80", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Jenkins Sequrity Group"
    Owner = "Sparrow"
  }
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.jenkins_server_instance.public_ip
}