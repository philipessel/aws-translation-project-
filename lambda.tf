/*
resource "aws_lambda_function" "translate_function" {
  function_name = var.lambda_function_name
  runtime       = "python3.9"
  handler       = "lambda_function.process_translation"
  role          = aws_iam_role.lambda_execution.arn
  filename      = "${path.module}/lambda_function.zip"

  tags = {
    Name = "Translate Processor Function"
  }
}


*/

resource "aws_lambda_function" "translation_api_function" {
  function_name = var.api_lambda_function_name 
  runtime       = "python3.9"
  handler       = "api_lambda.lambda_handler"   # Updated handler to a new script
  role          = aws_iam_role.lambda_execution.arn
  filename      = "${path.module}/api_lambda.zip"  # Updated ZIP file containing new code

  environment {
    variables = {
      REQUEST_BUCKET = aws_s3_bucket.requests.id
      RESPONSE_BUCKET = aws_s3_bucket.responses.id
    }
  }

  tags = {
    Name = "Translation API Function"
  }
}
