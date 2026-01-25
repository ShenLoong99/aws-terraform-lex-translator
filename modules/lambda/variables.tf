variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role used by the Lambda"
  type        = string
}

variable "lambda_logs" {
  description = "The translator lambda function log group"
  type        = string
}
