variable env {}
variable name {}
variable client_cidr {}
variable server_cert_arn {
  default = ""
}
variable active_directory_id {}
variable subnet_ids {}

variable retention_in_days {
  default = 5
}

variable "auth_type" {
  default     = "ad"
  description = "server_cert|ad|saml"
}