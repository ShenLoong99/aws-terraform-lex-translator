output "lambda_function_arn" {
  description = "The ARN of the Lambda function to be used in Lex fulfillment"
  value       = module.lambda.lambda_function_arn
}

output "iam_role_arn" {
  description = "The ARN of the IAM role used by the Lambda"
  value       = module.iam.iam_role_arn
}
