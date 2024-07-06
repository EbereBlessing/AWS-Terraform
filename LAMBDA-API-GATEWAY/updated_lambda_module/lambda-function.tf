# Package the v1 Lambda function
data "archive_file" "lambda_v1" {
  type        = "zip"
  source_file = "updated-lambda.py"
  output_path = "lambda_v1.zip"
}

# Create a new version v1 of the Lambda function
resource "aws_lambda_function" "canary_lambda_v1" {
  function_name = "canary_deployment2_function"
  runtime       = "python3.12"
  handler       = "lambda.lambda_handler"
  role          = aws_iam_role.iam_for_lambda.arn 
  filename      = data.archive_file.lambda_v1.output_path
  source_code_hash = data.archive_file.lambda_v1.output_base64sha256

  environment {
    variables = {
      VERSION = "v1"
    }
  }
  publish = true
}

# Update the alias to point to the new version
resource "aws_lambda_alias" "lambda_alias" {
  name             = "version1"
  function_name    = aws_lambda_function.canary_lambda_v1.function_name
  function_version = aws_lambda_function.canary_lambda_v1.version
}
