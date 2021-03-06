data aws_availability_zones all_azs {}

locals {
  azs_to_deploy = slice(data.aws_availability_zones.all_azs.names, 0, var.subnets_in_app_vpc)
  common_tags   = {
    "Environment"    = var.env
    "CostCode"       = var.cost_code
    "access_control" = var.access_control
  }
  namespace     = "lab"
}

module "private_vpc" {
  source                           = "cloudposse/vpc/aws"
  version                          = "0.26.1"
  namespace                        = local.namespace
  stage                            = var.env
  name                             = "app_vpc"
  cidr_block                       = var.app_vpc_cidr_block
  assign_generated_ipv6_cidr_block = false
  security_group_use_name_prefix = true
  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ALL egress traffic"
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.1.0.0/20"]
      description = "Allow SSH traffic from client vpn"
    }
  ]
  tags                             = merge(local.common_tags, {
    "Name": "app_vpc"
  })
}

module "dynamic_subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  version            = "0.39.3"
  namespace          = local.namespace
  stage              = var.env
  name               = "app"
  availability_zones = local.azs_to_deploy
  vpc_id             = module.private_vpc.vpc_id
  igw_id             = module.private_vpc.igw_id
  cidr_block         = var.app_vpc_cidr_block
}

module client_vpn_endpoint {
  source              = "./src/client_vpn_endpoint"
  name                = "aws_to_home"
  active_directory_id = var.directory_id
  client_cidr         = "10.1.0.0/20"
  env                 = var.env
  subnet_ids          = module.dynamic_subnets.public_subnet_ids
  subnet_cidrs        = module.dynamic_subnets.public_subnet_cidrs
}

module aerobase_sso {
  source = "./src/aerobase"
  env = var.env
  subnets = module.dynamic_subnets.private_subnet_ids
  security_groups = compact(concat([
    module.private_vpc.vpc_default_security_group_id], var.security_groups))
}

module "vpc_endpoints" {
  source  = "cloudposse/vpc/aws//modules/vpc-endpoints"
  version = "0.26.1"

  vpc_id = module.private_vpc.vpc_id

  gateway_vpc_endpoints   = {
    "s3" = {
      name   = "s3"
      policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
          {
            Action    = [
              "s3:*",
            ]
            Effect    = "Allow"
            Principal = "*"
            Resource  = "*"
          },
        ]
      })
    }
  }
  interface_vpc_endpoints = {
    "ec2" = {
      name                = "ec2"
      security_group_ids  = [
        module.private_vpc.security_group_id]
      # TODO needs work here
      subnet_ids          = module.dynamic_subnets.private_subnet_ids
      policy              = null
      private_dns_enabled = false
    }
  }
}
