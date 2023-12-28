###################################  QA clusters  ########################################
resource "aws_ecs_cluster" "cluster1" {
  name = "${var.env}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  tags = {
    "Environment" = "${var.env}"
  }
}







resource "aws_service_discovery_public_dns_namespace" "combyn_namespace" {
  name = "servicemap.combyn.net"
}


######### user-service staging ############



module "user_svc_staging_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "user-service-staging-sg"
}





module "user_svc_nlb" {
  nlb_port                   = 5000
  service_name               = "user-service-staging"
  source                     = "./ecs_service"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnets
  metric_name                = "MemoryUtilization"
  tg_port                    = 5000
  tg_timeout                 = 30
  health_check_path          = "/user.UserService/Check"
  health_check_success_codes = "0-16"
  lb_type                    = "nlb"
  container_port             = 5000
  tg_unhealthy_threshold     = 5
  tg_healthy_threshold       = 2
  tg_protocol                = "TCP"
  load_balancer_arn          = var.pulsar_lb["lb_arn"]
  tg_name                    = "user-service-staging"
  desired_count              = 1
  lb_dns_name                = var.pulsar_lb["lb_dns_name"]
  route53_zone_id            = var.combyn-zone_id
  fqdn                       = "user.staging.combyn.net"
  lb_zone_id                 = var.pulsar_lb["lb_zone_id"]
  ecs_cluster                = aws_ecs_cluster.cluster1.arn
  compute_info               = [1024, 2048]
  security_groups            = [module.user_svc_staging_sg.id]
  alb_arn_suffix             = var.pulsar_lb["lb_arn_suffix"]
  namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id

  container_definitions = {

    user-service-staging = {
      image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-user:staging"
      environment = var.user_service_staging_env
      secret      = var.user_service_staging_secrets
      port        = 5000
      command     = []
    }
  }

}





########### expense service staging ############


module "expense_svc_staging_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "expense-service-staging-sg"
}


module "expense_svc_nlb" {
  nlb_port                   = 5001
  service_name               = "expense-service-staging"
  source                     = "./ecs_service"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnets
  metric_name                = "MemoryUtilization"
  tg_port                    = 5001
  tg_timeout                 = 30
  health_check_path          = "/expense.ExpenseService/Check"
  health_check_success_codes = "0-16"
  lb_type                    = "nlb"
  container_port             = 5001
  tg_unhealthy_threshold     = 5
  tg_healthy_threshold       = 2
  tg_protocol                = "TCP"
  load_balancer_arn          = var.pulsar_lb["lb_arn"]
  tg_name                    = "expense-service-staging"
  desired_count              = 1
  lb_dns_name                = var.pulsar_lb["lb_dns_name"]
  route53_zone_id            = var.combyn-zone_id
  fqdn                       = "expense.staging.combyn.net"
  lb_zone_id                 = var.pulsar_lb["lb_zone_id"]
  ecs_cluster                = aws_ecs_cluster.cluster1.arn
  compute_info               = [1024, 2048]
  security_groups            = [module.expense_svc_staging_sg.id]
  alb_arn_suffix             = var.pulsar_lb["lb_arn_suffix"]
  namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
  container_definitions = {

    expense-service-staging = {
      image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-expense:staging"
      environment = var.expense_service_staging_env
      secret      = var.expense_service_staging_secrets
      port        = 5001
      command     = []
    }
  }
}




######## Notify service staging #############

module "notify_svc_staging_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "notify-service-staging-sg"
}



module "notify_svc_nlb" {
  nlb_port                   = 5002
  service_name               = "notify-service-staging"
  source                     = "./ecs_service"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnets
  metric_name                = "MemoryUtilization"
  tg_port                    = 5002
  tg_timeout                 = 30
  health_check_path          = "/notify.NotifyService/Check"
  health_check_success_codes = "0-16"
  lb_type                    = "nlb"
  container_port             = 5002
  tg_unhealthy_threshold     = 5
  tg_healthy_threshold       = 2
  tg_protocol                = "TCP"
  load_balancer_arn          = var.pulsar_lb["lb_arn"]
  tg_name                    = "notify-service-staging"
  desired_count              = 1
  lb_dns_name                = var.pulsar_lb["lb_dns_name"]
  route53_zone_id            = var.combyn-zone_id
  fqdn                       = "notify.staging.combyn.net"
  lb_zone_id                 = var.pulsar_lb["lb_zone_id"]
  ecs_cluster                = aws_ecs_cluster.cluster1.arn
  compute_info               = [1024, 2048]
  security_groups            = [module.expense_svc_staging_sg.id]
  alb_arn_suffix             = var.pulsar_lb["lb_arn_suffix"]
  namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
  container_definitions = {

    notify-service-staging = {
      image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-notify:staging"
      environment = var.notify_staging_env
      secret      = var.notify_service_staging_secrets
      port        = 5002
      command     = []
    }
  }


}




######## Api service staging #############

module "api_svc_staging_sg" {
  source       = "../security_group"
  rules        = var.api_svc_rules
  vpc_id       = var.vpc_id
  service_name = "api-service-staging-sg"
}





module "combyn_api_staging" {
  nlb_port                   = null
  service_name               = "api-service-staging"
  source                     = "./ecs_service"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnets
  container_port             = 5003
  tg_unhealthy_threshold     = 5
  tg_protocol_version        = "HTTP1"
  desired_count              = 1
  health_check_success_codes = "200,404"
  health_check_path          = "/health"
  tg_timeout                 = 20
  listener_arn               = var.staging_lb["listener_arn"][0]
  tg_name                    = "api-service-staging"
  lb_dns_name                = var.staging_lb["lb_dns_name"]
  route53_zone_id            = var.combyn-zone_id
  fqdn                       = "api.staging.combyn.net"
  lb_zone_id                 = var.staging_lb["lb_zone_id"]
  ecs_cluster                = aws_ecs_cluster.cluster1.arn
  enable_service_discovery   = true
  namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
  compute_info               = [256, 512]
  security_groups            = [module.api_svc_staging_sg.id]
  alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
  container_definitions = {

    "api-service-staging" = {
      image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-core-api:staging"
      environment = var.api_service_staging_env
      secret      = var.api_service_staging_secrets
      port        = 5003
      command     = []
    }
  }
  
  
  depends_on = [module.expense_svc_nlb, module.notify_svc_nlb, module.user_svc_nlb]

}


######## Frontend service staging #############

module "frontend_staging_sg" {
  source       = "../security_group"
  rules        = var.frontend_staging_rules
  vpc_id       = var.vpc_id
  service_name = "Frontend-service-staging-sg"
}



module "frontend_staging" {
  nlb_port                   = null
  service_name               = "frontend-service-staging"
  source                     = "./ecs_service"
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.private_subnets
  container_port             = 4201
  tg_unhealthy_threshold     = 5
  tg_protocol_version        = "HTTP1"
  desired_count              = 0
  health_check_success_codes = "200,404"
  health_check_path          = "/health"
  tg_timeout                 = 20
  listener_arn               = var.staging_lb["listener_arn"][0]
  tg_name                    = "frontend-service-staging"
  lb_dns_name                = var.staging_lb["lb_dns_name"]
  route53_zone_id            = var.combyn-zone_id
  fqdn                       = "front.staging.combyn.net"
  lb_zone_id                 = var.staging_lb["lb_zone_id"]
  ecs_cluster                = aws_ecs_cluster.cluster1.arn
  enable_service_discovery   = true
  namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
  compute_info               = [256, 512]
  security_groups            = [module.api_svc_staging_sg.id]
  alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
  container_definitions = {

    "frontend-service-staging" = {
      image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/frontend-svc:staging"
      environment = null
      secret      = null
      port        = 4201
      command     = []
    }
  }
  
  

}











# module "mongo" {
#   service_name           = "mongodb-staging"
#   source                 = "./ecs_service"
#   vpc_id                 = var.vpc_id
#   subnet_ids             = var.private_subnets
#   container_port         = 27017
#   tg_unhealthy_threshold = 5
#   tg_port                = 27017
#   # health_check_success_codes = "200-499"
#   lb_type                    = "nlb"
#   tg_protocol                = "TCP"
#   load_balancer_arn        = var.pulsar_lb["lb_arn"]
#   tg_name                  = "mongodb-staging"
#   lb_dns_name              = var.pulsar_lb["lb_dns_name"]
#   route53_zone_id          = var.combyn-zone_id
#   fqdn                     = "mongodb.staging.combyn.net"
#   lb_zone_id               = var.pulsar_lb["lb_zone_id"]
#   health_check_path      = null
#   desired_count            = 1
#   tg_timeout               = 20
#   ecs_cluster              = aws_ecs_cluster.cluster1.arn
#   enable_service_discovery = true
#   namespace_id             = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   compute_info             = [256, 512]
#   alb_arn_suffix           = var.pulsar_lb["lb_arn_suffix"]
#   security_groups          = [module.mongo_svc_sg.id]

#   container_definitions = {
#     mongodb-staging = {
#       image       = "mongo:jammy"
#       command     = []
#       port        = 27017
#       environment = null
#       secret      = var.mongodb_svc_secrets
#     }
#   }
# }




########### Mongodb ############

module "mongo_svc_sg" {
  source       = "../security_group"
  rules        = var.mongo_svc_rules
  vpc_id       = var.vpc_id
  service_name = "mongodb-staging"
}









###################################  services  ########################################
########## mongo server ############
# resource "aws_efs_file_system" "mongo" {
#   encrypted = true
#   tags = {
#     Name = "${var.env}-mongo"
#   }
# }
# module "efs_sg" {
#   source       = "../security_group"
#   rules        = var.mongo_efs_sg_rules
#   vpc_id       = var.vpc_id
#   service_name = "mongo-efs-${var.env}-sg"
# }

# resource "aws_efs_mount_target" "mongo" {
#   file_system_id  = aws_efs_file_system.mongo.id
#   subnet_id       = var.private_subnets[0]
#   security_groups = [module.efs_sg.id]
#   depends_on = [
#     aws_efs_file_system.mongo
#   ]
# }



# module "mongo_staging" {
#   service_name           = "mongodb-staging"
#   source                 = "./ecs_service"
#   vpc_id                 = var.vpc_id
#   subnet_ids             = var.public_subnets
#   metric_name            = "MemoryUtilization"
#   # add_container_volume   = true
#   tg_timeout             = 20
#   # efs_volume_name        = "mongo"
#   # efs_root_dir           = "data/"
#   tg_port                = 27017
#   health_check_path      = null
#   # efs_file_system_id     = aws_efs_file_system.mongo.id
#   lb_type                = "nlb"
#   container_port         = 27017
#   nlb_port               = 27017
#   tg_unhealthy_threshold = 5
#   tg_healthy_threshold   = 2
#   tg_protocol            = "TCP"
#   load_balancer_arn      = var.pulsar_lb["lb_arn"]
#   tg_name                = "mongodb-staging"
# desired_count              = 1
#   lb_dns_name            = var.pulsar_lb["lb_dns_name"]
#   route53_zone_id        = var.combyn-zone_id
#   fqdn                   = "mongodb.staging.combyn.net"
#   namespace_id             = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   lb_zone_id             = var.pulsar_lb["lb_zone_id"]
#   ecs_cluster            = aws_ecs_cluster.cluster1.arn
#   compute_info           = [1024, 2048]
#   security_groups        = [module.mongo_svc_sg.id]
#   alb_arn_suffix         = var.pulsar_lb ["lb_arn_suffix"]
#   container_definitions = {
#     mongodb-staging = {
#       image       = "mongo:jammy"
#       environment = null
#       secret      = null
#       port        = 27017
#       command     = []
#       # volumename  = "mongo"
#       # mount_path  = "/db/data/mongo/"
#     }
#   }
#   # depends_on = [
#   #   aws_efs_file_system.mongo
#   # ]
# }