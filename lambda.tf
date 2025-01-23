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



