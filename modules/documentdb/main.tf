# module "documentdb" {
#   source             = "./modules/documentdb"
# #   subnet_ids         = ["subnet-1", "subnet-2"] # Replace with your subnet IDs
# #   availability_zones = ["us-east-1a", "us-east-1b"] # Replace with your AZs
#   env = "staging"
#   instance_class = "db.r4.large"
#   subnet_ids = var.subnet_ids
#   availability_zones = var.availability_zones
# }


module "documentdb_cluster" {
  source = "./modules/documentdb"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  stage           = "testing"
  name            = "docdb"
  cluster_size    = 3
  master_username = "combyn"
  instance_class  = "db.r4.large"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_id
}