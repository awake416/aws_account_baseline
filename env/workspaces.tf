variable "oauth_token_id" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "directory_id" {}

module manage_workspaces {
  source  = "app.terraform.io/awake416/manage_workspaces/tfe"
  version = "0.0.5"

  env                   = "dev"
  prefix                = "aws_account_baseline"
  #  workspace_exec_mode = "local"
  oauth_token_id        = var.oauth_token_id
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}

resource tfe_variable directory_id {
  key          = "directory_id"
  value        = var.directory_id
  category     = "terraform"
  description  = "diredtory used in client vpn endpoint "
  workspace_id = module.manage_workspaces.workspace_id
}