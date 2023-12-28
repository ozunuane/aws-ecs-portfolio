output "nlb_info" {
  value = module.pulsar_lb.nlb_details
}

output "lb_info" {
  value = module.staging_services.lb_details
}


# output "sonar_sg_id" {
#   value = module.sonar_sg.id
# }

# output "sentry_sg_id" {
#   value = module.sentry_sg.id
# }


# output "elk_sg_id" {
#   value = module.sentry_sg.id
# }

# output "qa_temporal_lb" {
#   value = module.qa_temporalio.nlb_details
# }

