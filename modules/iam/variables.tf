variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "project_name" {
  description = "The name of the project for resource naming"
  type        = string
}

variable "default_tags" {
  description = "Extra tags to pass to the provider"
  type        = map(string)
}

variable "cloudwatch_arn" {
  description = "ARN of cloudwatch log group"
  type        = string
}

variable "function_name" {
  description = "The function name of the translator lambda function"
  type        = string
}
