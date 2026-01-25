# Local variables
locals {
  common_tags = {
    Project     = var.project_name
    Environment = "Dev"
    ManagedBy   = "Terraform"
    Owner       = "ShenLoong"
  }
}

# Module for IAM (Permissions, roles, policies)
module "iam" {
  source         = "./modules/iam"
  cloudwatch_arn = aws_cloudwatch_log_group.lambda_logs.arn
  function_name  = module.lambda.function_name
  project_name   = var.project_name
  aws_region     = var.aws_region
  default_tags   = local.common_tags
}

# Module for Lambda
module "lambda" {
  source       = "./modules/lambda"
  iam_role_arn = module.iam.iam_role_arn
  lambda_logs  = aws_cloudwatch_log_group.lambda_logs.name
  aws_region   = var.aws_region
  default_tags = local.common_tags
}

# Explicitly define the Log Group.
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/LexTranslationHandler"
  retention_in_days = 7 # Automatically deletes individual log streams after 7 days
  skip_destroy      = false

  tags = {
    Component = "Logging"
  }
}
