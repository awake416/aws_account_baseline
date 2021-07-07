variable region {
  type = string
  default = "us-east-1"
}

variable shared_cred_file {
  type = string
  default = ""
}

provider "aws" {
  region = var.region
//  shared_credentials_file = var.shared_cred_file
}