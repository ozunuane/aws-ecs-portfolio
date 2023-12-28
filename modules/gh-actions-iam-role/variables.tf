variable "gh_actions_user" {
  description = "The name of the Github Actions user"
  type        = string
  default     = ""
}

variable "gh_actions_secretsmanager" {
  description = "Secrets of the Github Actions user"
  type        = string
}

variable "deploy_role_arn_list" {
  description = "The ARN list of the Roles for the Github Actions"
  type        = list(string)
  default     = []
}


variable "github_user_arn" {
  description = "AWS github user arn"
  type        = string
  default     = ""
}

variable "deployment_role_name" {
  description = "The name of the Terraform IAM deployment role"
  type        = string
}
