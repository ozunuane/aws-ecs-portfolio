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

    values = ["pulsar-eventstore-with-promtail-loki"]
  }
}



resource "aws_instance" "pulsar" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type_value
  associate_public_ip_address = false
  key_name                    = "pulsar-key"
  subnet_id                   = var.private_subnets[2]
  vpc_security_group_ids      = [var.pulsar_sg_id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }


  tags = {
    "Name"      = "pulsar-${var.env}"
    "Lifecycle" = "staging"


  }
}