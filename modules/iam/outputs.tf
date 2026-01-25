output "iam_role_arn" {
  description = "The ARN of the IAM role used by the Lambda"
  value       = aws_iam_role.lambda_exec_role.arn
}
