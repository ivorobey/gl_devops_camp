provider "aws" {
  access_key = ""                     # insert your access_key here
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


resource "aws_instance" "ubuntu_instance" {
  count                  = 3
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name  = "linux-${count.index + 1}"
    Owner = "Sparrow"
  }
}

resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible_key"
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

resource "aws_security_group" "ansible_sg" {
  name = "Ansible Sequrity Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
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
    Name  = "Ansible Sequrity Group"
    Owner = "Sparrow"
  }
}

#files
resource "local_file" "ssh_key_file" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "/home/${var.username}/.ssh/tfkey.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.rsa]
}

resource "local_file" "ssh_cfg" {
  content = templatefile("../template/group_vars.tpl",
    {
      ssh = "/home/${var.username}/.ssh/tfkey.pem"
    }
  )
  filename = "../ansible/group_vars/all"
}

#create innventory
resource "local_file" "hosts_cfg" {
  content = templatefile("../template/hosts.tpl",
    {
      ubuntu_ip   = aws_instance.ubuntu_instance[0].public_ip
      ubuntu_ip_1 = aws_instance.ubuntu_instance[1].public_ip
      ubuntu_ip_2 = aws_instance.ubuntu_instance[2].public_ip
    }
  )
  filename = "../ansible/hosts.cfg"
}

output "ubuntu_instance_public_ip" {
  description = "Public IP of ubuntu instances"
  value       = ["${aws_instance.ubuntu_instance.*.public_ip}"]
}
