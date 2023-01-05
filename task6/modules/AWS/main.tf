resource "aws_instance" "moodle_server_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  key_name               = aws_key_pair.ssh_key.key_name
  user_data              = file("data_grafana.sh")

  tags = {
    Name  = "Grafana WebServer build by Terraform"
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

resource "aws_key_pair" "ssh_key" {
  key_name   = "grafana_key"
  default = "~/.ssh/id_rsa.pub"
}


resource "aws_security_group" "grafana_sg" {
  name = "Grafana Sequrity Group"

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
    Name  = "Grafana Sequrity Group"
    Owner = "Sparrow"
  }
}