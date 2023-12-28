resource "aws_iam_role" "lambda_role" {
  name               = "Spacelift_Test_Lambda_Function_Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents",
       "logs:CreateLogStream",
       "ec2:DescribeNetworkAcls",
       "ec2:DescribeVpcAttribute",
       "ec2:CreateNetworkAclEntry"
     ],
     "Resource": "*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}


#################   Intrusion prevention system   ###################
resource "aws_sns_topic" "topic" {
  name = "ips"
}


data "archive_file" "zip_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/code-files/"
  output_path = "${path.module}/scripts/zipped/ips.zip"
}

resource "aws_lambda_function" "ips" {
  filename      = "${path.module}/scripts/zipped/ips.zip"
  function_name = "Intrusion_prevention_system"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  environment {
    variables = {
      STARTING_RULE_NUMBER = 4000
    }
  }
}


resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ips.arn
  depends_on = [
    aws_lambda_function.ips
  ]
}
