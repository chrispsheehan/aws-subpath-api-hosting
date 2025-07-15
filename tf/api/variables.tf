
variable "api_name" {
  type        = string
  description = "Name of the lambda function"
}

variable "api_stage" {
  type        = string
  description = "Lambda api stage i.e. dev/qa/production"
}

variable "lambda_code_bucket" {
  type        = string
  description = "Lambda code s3 bucket name"
}

variable "lambda_code_s3_object" {
  type        = string
  description = "Lambda code s3 zip file key"
}
