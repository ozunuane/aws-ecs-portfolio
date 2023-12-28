
###################################  clusters  ########################################
resource "aws_ecs_cluster" "qa" {
  name = "qa-cluster"

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
    "Environment" = "qa"
  }
}



######### user-service staging ############
module "user_svc_qa_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "user-service-qa-sg"
}



# module "combyn_user_qa_svc" {
#   nlb_port                   = null
#   service_name               = "user-service-qa"
#   source                     = "./ecs_service"
#   vpc_id                     = var.vpc_id
#   subnet_ids                 = var.private_subnets
#   container_port             = 5000
#   tg_unhealthy_threshold     = 5
#   tg_protocol_version        = "GRPC"
#   desired_count              = 0
#   health_check_success_codes = "0-16"
#   health_check_path          = "/user.UserService/Check"
#   tg_timeout                 = 20
#   listener_arn               = var.staging_lb["listener_arn"][0]
#   tg_name                    = "user-service-qa"
#   lb_dns_name                = var.staging_lb["lb_dns_name"]
#   route53_zone_id            = var.combyn-zone_id
#   fqdn                       = "user.qa.combyn.net"
#   lb_zone_id                 = var.staging_lb["lb_zone_id"]
#   ecs_cluster                = aws_ecs_cluster.qa.arn
#   enable_service_discovery   = true
#   namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   compute_info               = [256, 512]
#   security_groups            = [module.user_svc_qa_sg.id]
#   alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
#   container_definitions = {

#     user-service-qa = {
#       image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-user:qa"
#       environment = var.user_service_staging_env
#       secret      = var.user_service_staging_secrets
#       port        = 5000
#       command     = []
#     }
#   }
# }







########### expense service staging ############


module "expense_svc_qa_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "expense-service-qa-sg"
}




# module "combyn_expense_qa_svc" {
#   nlb_port                   = null
#   service_name               = "expense-service-qa"
#   source                     = "./ecs_service"
#   vpc_id                     = var.vpc_id
#   subnet_ids                 = var.private_subnets
#   container_port             = 5001
#   tg_unhealthy_threshold     = 5
#   tg_protocol_version        = "GRPC"
#   desired_count              = 0
#   health_check_success_codes = "0-16"
#   health_check_path          = "/expense.ExpenseService/Check"
#   tg_timeout                 = 20
#   listener_arn               = var.staging_lb["listener_arn"][0]
#   tg_name                    = "expense-service-qa"
#   lb_dns_name                = var.staging_lb["lb_dns_name"]
#   route53_zone_id            = var.combyn-zone_id
#   fqdn                       = "expense.qa.combyn.net"
#   lb_zone_id                 = var.staging_lb["lb_zone_id"]
#   ecs_cluster                = aws_ecs_cluster.qa.arn
#   enable_service_discovery   = true
#   namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   compute_info               = [256, 512]
#   security_groups            = [module.expense_svc_qa_sg.id]
#   alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
#   container_definitions = {

#     expense-service-qa = {
#       image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-expense:qa"
#       environment = var.expense_service_staging_env
#       secret      = var.expense_service_staging_secrets
#       port        = 5001
#       command     = []
#     }
#   }
# }


######## Notify service staging #############

module "notify_svc_qa_sg" {
  source       = "../security_group"
  rules        = var.user_svc_rules
  vpc_id       = var.vpc_id
  service_name = "notify-service-qa-sg"
}




# module "combyn_notify_qa_svc" {
#   nlb_port                   = null
#   service_name               = "notify-service-qa"
#   source                     = "./ecs_service"
#   vpc_id                     = var.vpc_id
#   subnet_ids                 = var.private_subnets
#   container_port             = 5002
#   tg_unhealthy_threshold     = 5
#   tg_timeout                 = 10
#   tg_protocol_version        = "GRPC"
#   desired_count              = 0
#   health_check_success_codes = "0-16"
#   health_check_path          = "/notify.NotifyService/Check"
#   listener_arn               = var.staging_lb["listener_arn"][0]
#   tg_name                    = "notify-service-qa"
#   lb_dns_name                = var.staging_lb["lb_dns_name"]
#   route53_zone_id            = var.combyn-zone_id
#   fqdn                       = "notify.qa.combyn.net"
#   lb_zone_id                 = var.staging_lb["lb_zone_id"]
#   ecs_cluster                = aws_ecs_cluster.qa.arn
#   enable_service_discovery   = true
#   namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   compute_info               = [256, 512]
#   security_groups            = [module.notify_svc_qa_sg.id]
#   alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
#   container_definitions = {

#     notify-service-qa = {
#       image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-notify:qa"
#       environment = var.notify_staging_env
#       secret      = var.notify_service_staging_secrets
#       port        = 5002
#       command     = []
#     }
#   }
# }







######## Api service staging #############

module "api_svc_qa_sg" {
  source       = "../security_group"
  rules        = var.api_svc_rules
  vpc_id       = var.vpc_id
  service_name = "api-service-qa-sg"
}





# module "combyn_api_qa" {
#   nlb_port                   = null
#   service_name               = "api-service-qa"
#   source                     = "./ecs_service"
#   vpc_id                     = var.vpc_id
#   subnet_ids                 = var.private_subnets
#   container_port             = 5003
#   tg_unhealthy_threshold     = 5
#   tg_protocol_version        = "HTTP1"
#   desired_count              = 0
#   health_check_success_codes = "200"
#   health_check_path          = "/health"
#   tg_timeout                 = 20
#   listener_arn               = var.staging_lb["listener_arn"][0]
#   tg_name                    = "api-service-qa"
#   lb_dns_name                = var.staging_lb["lb_dns_name"]
#   route53_zone_id            = var.combyn-zone_id
#   fqdn                       = "api.qa.combyn.net"
#   lb_zone_id                 = var.staging_lb["lb_zone_id"]
#   ecs_cluster                = aws_ecs_cluster.qa.arn
#   enable_service_discovery   = true
#   namespace_id               = aws_service_discovery_public_dns_namespace.combyn_namespace.id
#   compute_info               = [256, 512]
#   security_groups            = [module.api_svc_qa_sg.id]
#   alb_arn_suffix             = var.staging_lb["lb_arn_suffix"]
#   container_definitions = {

#     "api-service-qa" = {
#       image       = "462612573069.dkr.ecr.us-east-1.amazonaws.com/sv-core-api:qa"
#       environment = var.api_service_staging_env
#       secret      = var.api_service_staging_secrets
#       port        = 5003
#       command     = []
#     }
#   }

# }