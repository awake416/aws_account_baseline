module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.16.1"
  attributes          = [
    "ssh",
    "key"]
  ssh_public_key_path = var.ssh_key_path
  generate_ssh_key    = var.generate_ssh_key

  context = module.this.context
}

variable "user_data" {
  default = "yum install -y postgresql-client-common"
}

variable "associate_public_ip_address" {
  default = "false"
}

variable "security_groups" {
  default = []
}
variable "instance_type" {
  default = "t3a.nano"
}
variable "enabled" {
  default = true
}
module ec2-bastion-server {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.28.0"

  enabled                     = var.enabled
  instance_type               = var.instance_type
  security_groups             = compact(concat([
    module.private_vpc.vpc_default_security_group_id], var.security_groups))
  subnets                     = module.dynamic_subnets.public_subnet_ids
  key_name                    = module.aws_key_pair.key_name
  user_data                   = var.user_data
  vpc_id                      = module.private_vpc.vpc_id
  associate_public_ip_address = var.associate_public_ip_address
  environment = var.env
}
