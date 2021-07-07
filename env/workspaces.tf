
variable "oauth_token_id" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

module manage_workspaces {
  source  = "app.terraform.io/awake416/manage_workspaces/tfe"
  version = "0.0.4"

  env = "dev"
  prefix = "aws_account_baseline"
//  workspace_exec_mode = "local"
  oauth_token_id = var.oauth_token_id
  aws_access_key_id = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}
