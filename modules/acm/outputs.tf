output "combyn_cert" {
  value = module.combyn_net_cert.cert_arn_dns
}

output "staging_combyn_cert" {
  value = module.staging_combyn_net.cert_arn_dns
}



# output "ozidevops.online" {
#   value = module.qa_combyn.cert_arn_dns
# }
