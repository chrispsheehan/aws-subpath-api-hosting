locals {
  domain              = "aws-subpath-api-hosting"
  lambda_code_bucket  = "${data.aws_caller_identity.current.account_id}-${local.domain}-lambda-code-bucket"
  alpha_api_name      = "alpha-api"
  beta_api_name       = "beta-api"
  default_root_object = "index.html"
  s3_origin_id        = "s3-root-origin"
  auth_header_name    = "X-Custom-Auth-Header"
}
