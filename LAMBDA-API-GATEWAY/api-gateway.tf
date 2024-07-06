# Define API Gateway Resource
resource "aws_api_gateway_rest_api" "api" {
  name = "canary deployment"
}
# Define API Gateway Stages
resource "aws_api_gateway_stage" "prod" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "stable"
  deployment_id = aws_api_gateway_deployment.prod.id
}

  # Integration with Primary Lambda
  resources = "{+}"
  methods    = ["GET"]
  type       = "AWS"

  # Replace with your Lambda ARN
  integration_settings = {
    passthrough_header = ["Content-Type", "Authorization"]
  }
  uri = aws_lambda_function.canary_lambda.arn
