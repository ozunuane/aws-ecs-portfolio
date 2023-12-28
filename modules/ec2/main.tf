####### Load Balancer ##########
module "pulsar_lb" {
  source             = "./load_balancer"
  vpc_id             = var.vpc_id
  service_cluster    = "pulsar"
  subnet_ids         = var.private_subnets
  load_balancer_type = "network"
  internal           = true
}

module "staging_services" {
  source                 = "./load_balancer"
  vpc_id                 = var.vpc_id
  service_cluster        = "services"
  subnet_ids             = var.public_subnets
  load_balancer_type     = "application"
  internal               = false
  https_default_cert_arn = var.https_default_cert_arn
  additional_cert        = true
  certificate_arn        = var.combyn_net_cert
}







data "aws_ami" "ubuntu_22" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230115"]

  }
}


#################### Pulsar Instance #######################

#PULSER DOCKER-COMPOSE-EC2 
module "pulsar_sg_id" {
  source       = "../security_group"
  rules        = var.pulsar_sg_rules
  vpc_id       = var.vpc_id
  env          = var.env
  service_name = "pulsar-ec2-${var.env}-sg"
}

module "pulsar_instance" {
  source          = "./pulsar"
  vpc_id          = var.vpc_id
  pulsar_sg_id    = module.pulsar_sg_id.id
  env             = var.env
  aws_subnet_id   = var.aws_subnet_id
  private_subnets = var.private_subnets
  fqdn            = "pulsar.combyn.net"
  listener_arn    = var.pulsar_lb["listener_arn"]
  route53_zone_id = var.combyn-zone_id
  lb_dns_name     = var.pulsar_lb["lb_dns_name"]
  lb_zone_id      = var.pulsar_lb["lb_zone_id"]
  public_subnets  = var.private_subnets
  volume_size     = 400

  depends_on = [
    module.pulsar_sg_id
  ]
}

######################### PULSAR SERVICE URL #########################


#################  pulser 6650  ###########################################
resource "aws_route53_record" "pulser_account_6650" {

  zone_id = var.combyn-zone_id
  name    = "pulsar-service.combyn.net"
  type    = "A"
  depends_on = [
    module.pulsar_instance
  ]

  alias {
    name                   = "dualstack.${var.pulsar_lb["lb_dns_name"]}"
    zone_id                = var.pulsar_lb["lb_zone_id"]
    evaluate_target_health = false
  }
}


resource "aws_lb_target_group" "pulsar_service_url" {
  name     = "pulsar1-service-url"
  port     = 6650
  protocol = "TCP"
  vpc_id   = var.vpc_id

  # stickiness {
  #   enabled = true
  #   type    = "lb_cookie"
  #   # duration = 36000
  # }

  # health_check {
  #   enabled             = true
  #   healthy_threshold   = 10
  #   interval            = 15
  #   # matcher             = "200-499"
  #   path                = "/"
  #   port                = "traffic-port"
  #   protocol            = "TCP"
  #   timeout             = 3
  #   unhealthy_threshold = 10
  # }

  # depends_on = [
  #   module.pulsar_instance.instance_id
  # ]

}
resource "aws_lb_listener" "pulserlb_listener" {
  load_balancer_arn = var.pulsar_lb["lb_arn"]
  port              = "6650"
  protocol          = "TCP"
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pulsar_service_url.arn

  }
}


resource "aws_lb_listener" "pulserlb_listener2" {
  load_balancer_arn = var.pulsar_lb["lb_arn"]
  port              = "8080"
  protocol          = "TCP"
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pulsar_service_url.arn

  }
}

resource "aws_lb_listener" "pulserlb_loki_listener" {
  load_balancer_arn = var.pulsar_lb["lb_arn"]
  port              = "3100"
  protocol          = "TCP"
  tags = {
    "Environment" = "${var.env}"
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pulsar_service_url.arn

  }
}








# resource "aws_lb_listener_rule" "pulser_web_lb_rule" {
#   listener_arn = aws_lb_listener.pulserlb_listener.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.pulsar_service_url.arn
#   }

#   condition {
#     host_header {
#       values = ["pulsar-service-url.combyn.net"]
#     }
#   }
# }


resource "aws_lb_target_group_attachment" "pulsar_service_url" {
  target_group_arn = aws_lb_target_group.pulsar_service_url.arn
  target_id        = module.pulsar_instance.pulsar_instance_id
}
################################################################################################################






#################### combyn frontend #######################

#Elk ec2 instance SG
module "dev_frontend_sg" {
  source       = "../security_group"
  rules        = var.dev_frontend_sg_rules
  vpc_id       = var.vpc_id
  env          = var.env
  service_name = "frontend-ec2-${var.env}-sg"
}


#dev_frontend_instance ec2 deployments
module "dev_frontend_instance" {
  source          = "./frontend"
  vpc_id          = var.vpc_id
  dev_frontend_sg_id     = module.dev_frontend_sg.id
  env             = var.env
  aws_subnet_id   = var.aws_subnet_id
  private_subnets = var.private_subnets
  fqdn            = "frontend-ec2.staging.combyn.net"
  listener_arn    = var.staging_lb["listener_arn"][0]
  route53_zone_id = var.combyn-zone_id
  lb_dns_name     = var.staging_lb["lb_dns_name"]
  lb_zone_id      = var.staging_lb["lb_zone_id"]
  public_subnets  = var.public_subnets

}
resource "aws_route53_record" "account_dns" {

  zone_id = var.combyn-zone_id
  name    = "frontend-ec2.staging.combyn.net"
  type    = "A"
  depends_on = [
    module.dev_frontend_instance
  ]

  alias {
    name                   = "dualstack.${var.staging_lb["lb_dns_name"]}"
    zone_id                = var.staging_lb["lb_zone_id"]
    evaluate_target_health = false
  }
}


resource "aws_lb_target_group" "dev_frontend" {
  name     = "combyn-frontend"
  port     = 4201
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = true
    type    = "lb_cookie"
    # duration = 36000
  }


  health_check {
    enabled             = true
    healthy_threshold   = 10
    interval            = 15
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 10
  }
  depends_on = [
    module.dev_frontend_instance
  ]
}


resource "aws_lb_listener_rule" "dev_frontend_lb_rule" {
  listener_arn = var.staging_lb["listener_arn"][0]
  priority     = 32

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_frontend.arn
  }

  condition {
    host_header {
      values = ["frontend-ec2.staging.combyn.net"]
    }
  }
}

resource "aws_lb_target_group_attachment" "attach_dev_frontend" {
  target_group_arn = aws_lb_target_group.dev_frontend.arn
  target_id        = module.dev_frontend_instance.instance_id
}
################################################






#################### Jenkins #######################

#Elk ec2 instance SG
module "jenkins_sg" {
  source       = "../security_group"
  rules        = var.jenkins_sg_rules
  vpc_id       = var.vpc_id
  env          = var.env
  service_name = "jenkins-ec2-sg"
}


#dev_frontend_instance ec2 deployments
module "jenkins_instance" {
  source          = "./jenkins"
  vpc_id          = var.vpc_id
  jenkins_sg_id     = module.jenkins_sg.id
  env             = var.env
  aws_subnet_id   = var.aws_subnet_id
  private_subnets = var.private_subnets
  fqdn            = "jenkins.combyn.net"
  listener_arn    = var.staging_lb["listener_arn"][0]
  route53_zone_id = var.combyn-zone_id
  lb_dns_name     = var.staging_lb["lb_dns_name"]
  lb_zone_id      = var.staging_lb["lb_zone_id"]
  public_subnets  = var.public_subnets
  key_name                    = "pulsar-key"


}
resource "aws_route53_record" "jenkins_account_dns" {

  zone_id = var.combyn-zone_id
  name    = "jenkins.combyn.net"
  type    = "A"
  depends_on = [
    module.dev_frontend_instance
  ]

  alias {
    name                   = "dualstack.${var.staging_lb["lb_dns_name"]}"
    zone_id                = var.staging_lb["lb_zone_id"]
    evaluate_target_health = false
  }
}


resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }


  health_check {
    enabled             = true
    healthy_threshold   = 10
    interval            = 15
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 10
  }
  depends_on = [
    module.dev_frontend_instance
  ]
}


resource "aws_lb_listener_rule" "jenkins_lb_rule" {
  listener_arn = var.staging_lb["listener_arn"][0]
  priority     = 12

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    host_header {
      values = ["jenkins.combyn.net"]
    }
  }
}

resource "aws_lb_target_group_attachment" "attach_jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id        = module.jenkins_instance.instance_id
}
################################################







resource "aws_route53_record" "grafana_account_dns" {

  zone_id = var.combyn-zone_id
  name    = "monitoring.combyn.net"
  type    = "A"
  depends_on = [
    module.dev_frontend_instance
  ]

  alias {
    name                   = "dualstack.${var.staging_lb["lb_dns_name"]}"
    zone_id                = var.staging_lb["lb_zone_id"]
    evaluate_target_health = false
  }
}


resource "aws_lb_target_group" "grafana" {
  name     = "monitoring"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }


  health_check {
    enabled             = true
    healthy_threshold   = 10
    interval            = 15
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 10
  }
  depends_on = [
    module.dev_frontend_instance
  ]
}


resource "aws_lb_listener_rule" "grafana_lb_rule" {
  listener_arn = var.staging_lb["listener_arn"][0]
  priority     = 13

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  condition {
    host_header {
      values = ["monitoring.combyn.net"]
    }
  }
}

resource "aws_lb_target_group_attachment" "attach_grafana" {
  target_group_arn = aws_lb_target_group.grafana.arn
  target_id        = module.jenkins_instance.instance_id
}
################################################

