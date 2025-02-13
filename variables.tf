/*
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

*/

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

variable "api_lambda_function_name" {
  default     = "translateProcessor"
  description = "Name of the Lambda function"
}

variable "api_gateway_name" {
  default     = "TranslationAPI"
  description = "Name of the API Gateway"
}

variable "api_gateway_stage" {
  default     = "prod"
  description = "Stage name for API Gateway deployment"
}

variable "api_gateway_resource_path" {
  default     = "translate"
  description = "Resource path for API Gateway (e.g., /translate)"
}
