module "network" {
  source                 = "./modules/vpc"
  cidr_block             = "10.10.0.0/16"
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  env                    = "staging"
  staging_private_routes = var.staging_private_routes
  staging_public_routes  = var.staging_public_routes
  staging_nacl_rules     = var.staging_nacl_rules
}


# # # github-actions
# # module "github_actions" {
# #   source = "./modules/gh-actions-iam-role"
# #   gh_actions_user = "github-actions-user"
# #   deployment_role_name = "github-terraform-user"  
# #   gh_actions_secretsmanager = "github-actions"
# # }

module "dns" {
  source = "./modules/dns"
}


module "ecr" {
  source = "./modules/ecr"
}


module "certificates" {
  source = "./modules/acm"
}



module "ec2" {
  source                 = "./modules/ec2"
  private_subnets        = module.network.private_subnets
  vpc_id                 = module.network.id
  https_default_cert_arn = module.certificates.staging_combyn_cert
  aws_subnet_id          = module.network.public_subnets[0]
  staging_lb             = module.ec2.lb_info
  pulsar_lb              = module.ec2.nlb_info
  combyn-zone_id         = module.dns.combyn_zone_id
  combyn_net_cert            = module.certificates.combyn_cert
  public_subnets         = module.network.public_subnets
}


module "ecs" {
  source          = "./modules/ecs"
  vpc_id          = module.network.id
  private_subnets = module.network.private_subnets
  combyn-zone_id  = module.dns.combyn_zone_id
  pulsar_lb       = module.ec2.nlb_info
  staging_lb      = module.ec2.lb_info
  public_subnets  = module.network.public_subnets

  # qa_temporalio_lb = module.ec2.qa_temporal_lb
}



module "twingate" {
  tg_api_key    = var.combyn_tg_api_key
  source        = "./modules/twingate"
  vpc_id        = module.network.id
  aws_subnet_id = module.network.public_subnets[0]
}






# module "mongb" {
#   source = "./modules/documentdb/db"
#   vpc_id = module.network.id
#   subnet_ids = [module.network.private_subnets[2]]
#   availability_zones = [module.network.private_subnets[2]]
#   env ="staging"
#   instance_class = "db.r4.large"
# }

# # # module "lambda" {
# # #   source = "./modules/lambda"
# # # }



# staging-server.eo3out.ng.0001.use1.cache.amazonaws.com:6379