
output "EC2_ip" {
  value = aws_instance.grafana_server_instance.public_ip
}