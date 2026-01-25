output "lambda_function_arn" {
  description = "The ARN of the Lambda function to be used in Lex fulfillment"
  value       = aws_lambda_function.translator_lambda.arn
}

output "function_name" {
  description = "The function name of the translator lambda function"
  value       = aws_lambda_function.translator_lambda.function_name
}
