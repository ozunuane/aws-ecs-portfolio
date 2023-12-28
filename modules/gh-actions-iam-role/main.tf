# Common IAM resources
resource "aws_iam_user" "gh_actions" {
  force_destroy = true
  name          = var.gh_actions_user
  tags = {
    Name = var.gh_actions_user
  }
}




resource "aws_iam_user_policy" "gh_actions" {
  count       = length(var.deploy_role_arn_list) == 0 ? 0 : 1
  name_prefix = "assume-gh-deployment-role-prod-"
  user        = aws_iam_user.gh_actions.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect   = "Allow"
        Resource = var.deploy_role_arn_list
      },
    ]
  })
}

resource "aws_iam_access_key" "gh_actions" {
  user = aws_iam_user.gh_actions.name
}

# Create SSM for store secrets for "gh_actions"
resource "aws_secretsmanager_secret" "gh_actions" {
  description             = "GitHub Actions user's secrets"
  name                    = var.gh_actions_secretsmanager
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gh_actions" {
  secret_id = aws_secretsmanager_secret.gh_actions.id
  secret_string = jsonencode(
    {
      "AccessKey"       = aws_iam_access_key.gh_actions.id,
      "SecretAccessKey" = aws_iam_access_key.gh_actions.secret,
    }
  )
}



data "aws_iam_policy_document" "gh_actions" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.gh_actions.arn]
    }
  }
}

resource "aws_iam_policy" "deployment_role" {
  name_prefix = "gh-deployment-policy-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowSpecifics"
        Action = [
          "lambda:*",
          "apigateway:*",
          "acm:*",
          "ec2:*",
          "rds:*",
          "s3:*",
          "sns:*",
          "states:*",
          "ssm:*",
          "sqs:*",
          "iam:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "cloudfront:*",
          "route53:*",
          "ecr:*",
          "logs:*",
          "ecs:*",
          "application-autoscaling:*",
          "logs:*",
          "events:*",
          "es:*",
          "kms:*",
          "dynamodb:*",
          "apprunner:*",
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid : "DenySpecifics"
        Action = [
          "consolidatedbilling:*",
          "invoicing:*",
          "account:*",
          "payments:*",
          "budgets:*",
          "tax:*",
          "ce:*",
          "cur:*",
          "freetier:*",
          "billing:*",
          "config:*",
          "directconnect:*",
          "aws-marketplace:*",
          "aws-marketplace-management:*",
          "ec2:*ReservedInstances*",
        ]
        Effect   = "Deny"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "deployment_role" {
  force_detach_policies = true
  name_prefix           = var.deployment_role_name
  assume_role_policy    = data.aws_iam_policy_document.gh_actions.json
  managed_policy_arns = [
    aws_iam_policy.deployment_role.arn
  ]
  tags = {
    Name = var.deployment_role_name
  }
}
