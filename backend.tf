terraform {
  backend remote {
    organization = "awake416"

    workspaces {
      prefix = "aws_account_baseline-"
    }
  }

  required_version = ">= 0.13.0"
}
