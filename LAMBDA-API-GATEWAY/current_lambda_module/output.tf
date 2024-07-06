output "lambda_function_arn" {
  value = aws_lambda_function.canary_lambda.arn
}
output "lambda_alias_arn" {
  value = aws_lambda_alias.lambda_alias.arn
}