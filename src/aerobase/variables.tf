variable "generate_ssh_key" {
  default = true
}

variable "env" {}
variable "security_groups" {}
variable "subnets" {}

variable "ami_owner" {
  default = "137112412989"
}

variable "ami_id" {
  default = "ami-0dc2d3e4c0f9ebd18"
}

data aws_vpc vpc {
  filter {
    name   = "tag:Name"
    values = ["app_vpc"]
  }
}