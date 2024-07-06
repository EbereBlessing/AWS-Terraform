output "lambda_function_arn" {
  value = aws_lambda_function.canary_lambda_v1.arn
}
output "lambda_alias_arn" {
  value = aws_lambda_alias.lambda_alias_v1.arn

  
}