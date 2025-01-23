output "s3_request_bucket" {
  value = aws_s3_bucket.requests.id
}

output "s3_response_bucket" {
  value = aws_s3_bucket.responses.id
}

output "lambda_function_name" {
  value = aws_lambda_function.translate_function.function_name
}
