# API Gateway
resource "aws_api_gateway_rest_api" "canary_api" {
  name        = "canary_deployment"
  description = "API for canary deployment"
}

resource "aws_api_gateway_resource" "canary_resource" {
  rest_api_id = aws_api_gateway_rest_api.canary_api.id
  parent_id   = aws_api_gateway_rest_api.canary_api.root_resource_id
  path_part   = "canary"
}
resource "aws_api_gateway_method" "canary_method" {
  rest_api_id   = aws_api_gateway_rest_api.canary_api.id
  resource_id   = aws_api_gateway_resource.canary_resource.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "canary_integration" {
  rest_api_id = aws_api_gateway_rest_api.canary_api.id
  resource_id = aws_api_gateway_resource.canary_resource.id
  http_method = aws_api_gateway_method.canary_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "GET"
  uri         = aws_lambda_function.canary_lambda.invoke_arn
}
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.canary_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.canary_api.execution_arn}/*/*"
}
# Deployment
resource "aws_api_gateway_deployment" "canary_deployment" {
  depends_on = [
    aws_api_gateway_method.canary_method,
    aws_api_gateway_integration.canary_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  stage_name  = "prod"
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.todo_deployment.invoke_url}/todos"
}