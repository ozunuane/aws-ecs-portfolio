output "github_iam_role_arn" {
  value = aws_iam_role.deployment_role.arn
}


output "github_user_arn" {
  value = aws_iam_user.gh_actions.arn
}