variable "region" {
  type        = string
  description = "The AWS Region to use"
  default     = "eu-west-2"
}

variable "function_name" {
  type        = string
  description = "Name of the lambda function"
  default     = "aws-subpath-api-hosting"
}

variable "function_stage" {
  type        = string
  description = "Lambda api stage i.e. dev/qa/production"
  default     = "dev"
}

variable "lambda_zip_path" {
  type        = string
  description = "Lambda code (zipped) to be deployed"
}
