# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda_exec_role" {
  name = "lex_translator_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# --- Permissions: CloudWatch Logs & Amazon Translate ---
resource "aws_iam_policy" "lambda_logging_translate" {
  name        = "${var.project_name}-policy" # Use variable for naming consistency [cite: 9]
  description = "Allows Lambda to log, translate text, and detect languages"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        # BEST PRACTICE: Restrict logs to the specific ARN of your managed Log Group
        Resource = "${var.cloudwatch_arn}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "translate:TranslateText",
          "comprehend:DetectDominantLanguage"
        ],
        Resource = "*" # Translate is a global service and often requires "*"
      }
    ]
  })
}

# --- Attach IAM Policy to Role ---
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_logging_translate.arn
}

# --- Lex Permission to Invoke Lambda ---
resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowExecutionFromLex"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "lex.amazonaws.com"
}
