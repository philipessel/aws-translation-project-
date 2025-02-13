/*
resource "aws_s3_bucket" "requests" {
  bucket = "${var.s3_request_bucket}-229895649975"

  tags = {
    Name = "Translation-Requests-Bucket"
  }
}

resource "aws_s3_bucket" "responses" {
  bucket = "${var.s3_response_bucket}-229895649975"

  tags = {
    Name = "Translation-Responses-Bucket"
  }
}

# Optional: Define default bucket policies for restricted access
resource "aws_s3_bucket_policy" "requests_policy" {
  bucket = aws_s3_bucket.requests.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "${aws_s3_bucket.requests.arn}",
          "${aws_s3_bucket.requests.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" : "false" }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "responses_policy" {
  bucket = aws_s3_bucket.responses.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "${aws_s3_bucket.responses.arn}",
          "${aws_s3_bucket.responses.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" : "false" }
        }
      }
    ]
  })
}

# Grant S3 bucket permission to invoke the Lambda function
resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.translate_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.requests.arn
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "requests_notification" {
  bucket = aws_s3_bucket.requests.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.translate_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_invoke_lambda]
}

*/

resource "aws_s3_bucket" "requests" {
  bucket = "${var.s3_request_bucket}-229895649975"

  tags = {
    Name = "Translation-Requests-Bucket"
  }
}

resource "aws_s3_bucket" "responses" {
  bucket = "${var.s3_response_bucket}-229895649975"

  tags = {
    Name = "Translation-Responses-Bucket"
  }
}

# Optional: Define default bucket policies for restricted access
resource "aws_s3_bucket_policy" "requests_policy" {
  bucket = aws_s3_bucket.requests.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource  = [
          "${aws_s3_bucket.requests.arn}",
          "${aws_s3_bucket.requests.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" : "false" }
        }
      },
      {
        Sid       = "AllowLambdaInvoke",
        Effect    = "Allow",
        Principal = { Service = "s3.amazonaws.com" },
        Action    = "lambda:InvokeFunction",
        Resource  = aws_lambda_function.translation_api_function.arn
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "responses_policy" {
  bucket = aws_s3_bucket.responses.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyPublicAccess",
        Effect    = "Deny",
        Principal = "*",
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource  = [
          "${aws_s3_bucket.responses.arn}",
          "${aws_s3_bucket.responses.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" : "false" }
        }
      }
    ]
  })
}

# Grant S3 bucket permission to invoke the Lambda function
resource "aws_lambda_permission" "s3_invoke_lambda" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.translation_api_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.requests.arn
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "requests_notification" {
  bucket = aws_s3_bucket.requests.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.translation_api_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_invoke_lambda]
}
