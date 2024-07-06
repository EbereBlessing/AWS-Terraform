# Configure AWS Provider
provider "aws" {
  region = "us-west-2" # Replace with your desired region
}

module "current_lambda_module" {
  source       = "./current_lambda_module"
  aws_region   = "us-west-2"
  source_file  = "lambda.py"
  output_path  = ""lambda.zip"
  function_name = "canary-deployment"
  runtime      = "python3.12"
  handler      = "lambda.lambda_handler"
  version      = "current"
  alias_name   = "stable_version"
  role_arn     = aws_iam_role.iam_for_lambda.arn
}

module "updated_lambda_module" {
  source       = "./updated_lambda_module"
  aws_region   = "us-west-2"
  source_file  = "lambda.py"
  output_path  = "lambda_v1.zip"
  function_name = "canary_deployment2_function"
  runtime      = "python3.12"
  handler      = "lambda.lambda_handler"
  version      = "v1"
  alias_name   = "version1"
  role_arn     = aws_iam_role.lambda_exec_role.arn
}

output "lambda_function_1_arn" {
  value = module.current_lambda_module_function_arn
}

output "lambda_function_2_arn" {
  value = module.updated_lambda_module_function_arn
}