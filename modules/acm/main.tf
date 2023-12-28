# module "pulsar" {
#   source                      = "./certs"
#   domain_name                 = "backend.combyn.net"
#   domain_validation_options   = "DNS"
#   subject_alternative_names   = ["*.backend.combyn.net", "backend.combyn.net"]
#   wait_for_certificate_issued = true
# }

module "combyn_net_cert" {
  source                      = "./certs"
  domain_name                 = "combyn.net"
  domain_validation_options   = "DNS"
  subject_alternative_names   = ["*.combyn.net", "combyn.net"]
  wait_for_certificate_issued = true
}


module "staging_combyn_net" {
  source                      = "./certs"
  domain_name                 = "combyn.net"
  domain_validation_options   = "DNS"
  subject_alternative_names   = ["*.staging.combyn.net", "staging.combyn.net"]
  wait_for_certificate_issued = true
  dns_zone                    = "combyn.net"
  allow_overwrite             = false

}





