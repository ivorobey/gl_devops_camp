variable "user_data" {
  type    = string
  default = "data_grafana.sh"
}

# Azure Public Key file
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}