# This archives the Python file into a ZIP before deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "translator_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "LexTranslationHandler"
  role             = var.iam_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10                # Set to 10s to allow for network jitter without wasting money on hang-ups.
  memory_size      = 128               # 128MB is sufficient. Increasing this also increases CPU power.
  depends_on       = [var.lambda_logs] # Explicit dependency ensures the log group exists before the Lambda tries to log

  tracing_config {
    mode = "Active"
  }

  tags = {
    Name = "LexTranslatorBackend"
  }
}
