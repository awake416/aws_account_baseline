variable "generate_ssh_key" {
  default = true
}

variable "env" {}
variable "security_groups" {}
variable "subnets" {}

data aws_vpc vpc {
  filter {
    name   = "tag:Name"
    values = ["app_vpc"]
  }
}