locals {
  root_cert_chain = var.auth_type == "server_cert" ? var.server_cert_arn : null
}

resource aws_cloudwatch_log_group client_vpn_lg {
  name              = "/aws/net-vpn/${var.name}/"
  retention_in_days = var.retention_in_days
  tags              = {
    Name = var.name
    env  = var.env
  }
}

resource aws_cloudwatch_log_stream client_vpn_stream {
  log_group_name = aws_cloudwatch_log_group.client_vpn_lg.name
  name           = "{$name}-stream.log"
}

resource aws_ec2_client_vpn_endpoint client_vpn {
  server_certificate_arn = var.server_cert_arn
  client_cidr_block      = var.client_cidr
  description            = "Client VPN Endpoint for - ${var.name}"
  dns_servers            = []
  split_tunnel           = true
  transport_protocol     = "tcp"

  authentication_options {
    type                       = var.auth_type
    active_directory_id        = var.active_directory_id
    root_certificate_chain_arn = local.root_cert_chain
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn_lg.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.client_vpn_stream.name
  }

  tags = {
    Name = var.name
    env  = var.env
  }

}

resource "aws_ec2_client_vpn_network_association" client_vpn {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  subnet_id              = element(var.subnet_ids, count.index)
}