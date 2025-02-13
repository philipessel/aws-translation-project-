/*
output "s3_request_bucket" {
  value = aws_s3_bucket.requests.id
}

output "s3_response_bucket" {
  value = aws_s3_bucket.responses.id
}

output "lambda_function_name" {
  value = aws_lambda_function.translate_function.function_name
}
*/


output "s3_request_bucket" {
  value = aws_s3_bucket.requests.id
}

output "s3_response_bucket" {
  value = aws_s3_bucket.responses.id
}

output "api_lambda_function_name" {
  value = aws_lambda_function.translation_api_function.function_name
}

output "api_gateway_invoke_url" {
  value       = aws_api_gateway_stage.translation_api_stage.invoke_url
  description = "The URL to invoke the API Gateway"
}

