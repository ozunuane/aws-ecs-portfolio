module "combyne-staging-repos" {
  source   = "./ecr_module"
  ecr_repo = var.ecr_repo
}