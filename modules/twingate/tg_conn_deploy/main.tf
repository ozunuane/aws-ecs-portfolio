terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "0.2.1"
    }
  }
}


resource "twingate_connector" "aws_connector" {
  remote_network_id = var.aws_network_id
}

resource "twingate_connector_tokens" "aws_connector_tokens" {
  connector_id = twingate_connector.aws_connector.id
}

resource "aws_instance" "twingate_connector" {
  ami                         = var.twingate_ami
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOT
    #!/bin/bash
    set -e
    mkdir -p /etc/twingate/
    {
      echo TWINGATE_URL="https://${var.tg_network}.twingate.com"
      echo TWINGATE_ACCESS_TOKEN="${twingate_connector_tokens.aws_connector_tokens.access_token}"
      echo TWINGATE_REFRESH_TOKEN="${twingate_connector_tokens.aws_connector_tokens.refresh_token}"
    } > /etc/twingate/connector.conf
    sudo systemctl enable --now twingate-connector
  EOT

  subnet_id = var.aws_subnet_id

  vpc_security_group_ids = var.twingate_sg

  tags = {
    "Name"      = "twingate-${var.env}-connector"
    "Lifecycle" = "staging"

  }
}