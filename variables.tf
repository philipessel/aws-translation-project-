variable "region" {
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "s3_request_bucket" {
  default     = "translation-requests"
  description = "S3 bucket for storing input files"
}

variable "s3_response_bucket" {
  default     = "translation-responses"
  description = "S3 bucket for storing output files"
}

variable "lambda_function_name" {
  default     = "translateProcessor"
  description = "Name of the Lambda function"
}
