variable "app_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "inet_vpc_cidr_block" {
  default = "10.1.0.0/16"
}

variable "subnets_in_app_vpc" {
  default = 2
}

variable "env" {
}
variable "cost_code" {
  default = "C-001"
}

variable "access_control" {
  default = "infra"
}

variable "directory_id" {
  default = ""
}

variable AWS_ACCESS_KEY_ID {}
variable AWS_SECRET_ACCESS_KEY {}