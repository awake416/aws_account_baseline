terraform {
  backend remote {
    organization = "awake416"

    workspaces {
      prefix = "aws_account_baselines-"
    }
  }

  required_version = ">= 0.13.0"
}
