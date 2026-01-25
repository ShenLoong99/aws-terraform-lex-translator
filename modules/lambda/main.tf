# This archives the Python file into a ZIP before deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "translator_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "LexTranslationHandler"
  role          = var.iam_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"

  # Set to 10s to allow for network jitter without wasting money on hang-ups.
  timeout = 10

  # 128MB is sufficient. Increasing this also increases CPU power.
  memory_size = 128

  # Explicit dependency ensures the log group exists before the Lambda tries to log
  depends_on = [var.lambda_logs]

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name = "LexTranslatorBackend"
  }
}
