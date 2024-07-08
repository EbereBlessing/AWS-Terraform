# Compressing the .py file with it dependencies
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "${path.module}/lambda.zip"
}
resource "aws_lambda_function" "canary_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  handler       = "lambda.lambda_handler"
  function_name = "canary-deployment"
  role          = aws_iam_role.iam_for_lambda.arn
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime       = "python3.12"

}