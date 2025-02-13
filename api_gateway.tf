# Create API Gateway
resource "aws_api_gateway_rest_api" "translation_api" {
  name        = var.api_gateway_name
  description = "API Gateway for handling translation requests via Lambda"
}

# Define API Gateway Resource (Endpoint Path)
resource "aws_api_gateway_resource" "translate" {
  rest_api_id = aws_api_gateway_rest_api.translation_api.id
  parent_id   = aws_api_gateway_rest_api.translation_api.root_resource_id
  path_part   = var.api_gateway_resource_path
}

# Define API Gateway Method (HTTP POST)
resource "aws_api_gateway_method" "translate_post" {
  rest_api_id   = aws_api_gateway_rest_api.translation_api.id
  resource_id   = aws_api_gateway_resource.translate.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define API Gateway Method (HTTP GET)
resource "aws_api_gateway_method" "translate_get" {
  rest_api_id   = aws_api_gateway_rest_api.translation_api.id
  resource_id   = aws_api_gateway_resource.translate.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integration: Connect API Gateway to Lambda (POST)
resource "aws_api_gateway_integration" "lambda_post" {
  rest_api_id = aws_api_gateway_rest_api.translation_api.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.translation_api_function.invoke_arn
}

# Integration: Connect API Gateway to Lambda (GET)
resource "aws_api_gateway_integration" "lambda_get" {
  rest_api_id = aws_api_gateway_rest_api.translation_api.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate_get.http_method

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.translation_api_function.invoke_arn
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "translation_api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_post, aws_api_gateway_integration.lambda_get]
  rest_api_id = aws_api_gateway_rest_api.translation_api.id
  description = "Deployment of Translation API"
}

# Create API Gateway Stage
resource "aws_api_gateway_stage" "translation_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.translation_api.id
  deployment_id = aws_api_gateway_deployment.translation_api_deployment.id
  stage_name    = var.api_gateway_stage
}

# Grant permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.translation_api_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.translation_api.execution_arn}/*/*"
}
