# #### Retrieving SSM Database data ##########
# data "aws_ssm_parameter" "db_username" {
#   name = "/software/staging/sonar/sonar_username"
# }

# data "aws_ssm_parameter" "db_password" {
#   name = "/software/staging/sonar/sonar_password"
# }

# data "aws_ssm_parameter" "db_url" {
#   name = "/software/staging/sonar/database-url"
# }



# resource "aws_key_pair" "deployer" {
#   key_name   = var.key_name
#   # public_key = file("sonariac.pem")
# }


data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name = "name"

    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"]
        values = ["combyn-frontend"]


  }
}



resource "aws_instance" "dev_frontend" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type_value
  associate_public_ip_address = true
  key_name                    = "pulsar-key"
  subnet_id                   = var.private_subnets[2]
  vpc_security_group_ids      = [var.dev_frontend_sg_id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nodejs npm
            
              EOF

  tags = {
    "Name"      = "frontend-${var.env}"
    "Lifecycle" = "staging"


  }
}