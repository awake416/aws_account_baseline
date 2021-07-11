module aws_key_pair {
  source              = "cloudposse/key-pair/aws"
  version             = "0.16.1"
  attributes          = [
    "ssh",
    "key",
    "aerobase"]
  ssh_public_key_path = "./security/"
  generate_ssh_key    = var.generate_ssh_key
}

resource aws_secretsmanager_secret private_key {
  description = "aerobase host ssh key"
  name        = "aerobase_private_key"
  tags        = {
    Name        = "aerobase_private_key"
    Environment = var.env
  }
}

resource aws_secretsmanager_secret_version private_key {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = module.aws_key_pair.private_key
}

resource aws_secretsmanager_secret public_key {
  description = "aerobase public key"
  name        = "aerobase_public_key"
  tags        = {
    Name        = "aerobase_public_key"
    Environment = var.env
  }
}

module "aerobase_instance" {
  source = "cloudposse/ec2-instance/aws"

  ssh_key_pair                = module.aws_key_pair.key_name
  vpc_id                      = data.aws_vpc.vpc.id
  security_groups             = var.security_groups
  subnet                      = var.subnets[0]
  # One per subnet if required :-)
  associate_public_ip_address = true
  name                        = "aerobase-standalone"
  namespace                   = "lab"
  stage                       = var.env
#  additional_ips_count        = 1
  assign_eip_address          = false
  ebs_volume_count            = 1
  user_data                   = file("${path.module}/install_aerobase.sh")
  security_group_rules        = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = [
        "0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = [
        "0.0.0.0/0"]
    },
  ]
}
