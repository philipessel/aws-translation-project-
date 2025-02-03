resource "aws_iam_role" "lambda_execution" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "lambda.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Define the custom policy for AWS Translate
resource "aws_iam_policy" "custom_translate_policy" {
  name        = "CustomAmazonTranslateFullAccess"
  description = "Grants full access to AWS Translate"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["translate:*"],
        Resource = "*"
      }
    ]
  })
}

# Attach the custom AWS Translate policy to the IAM role
resource "aws_iam_role_policy_attachment" "translate_access" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.custom_translate_policy.arn
}

# Attach the Amazon S3 Full Access managed policy
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach the cloudwatch logs access managed policy:this will ensure that Lambda has the permission to write logs to CloudWatch.

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_access" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
