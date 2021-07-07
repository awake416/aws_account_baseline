terraform {
  backend remote {
    organization = "awake416"

    workspaces {
      prefix = "manage_aws_organizations-"
    }
  }

  required_version = ">= 0.13.0"
}


//terraform {
//  backend remote {
//    organization = "awake416"
//
//    workspaces {
//      name = "manage_aws_organizations-feature"
//    }
//  }
//}