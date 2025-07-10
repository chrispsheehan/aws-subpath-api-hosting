locals {
  domain              = "aws-subpath-api-hosting"
  lambda_code_bucket  = "${data.aws_caller_identity.current.account_id}-${local.domain}-lambda-code-bucket"
  static_web_files_bucket = "${data.aws_caller_identity.current.account_id}-${local.domain}"
  alpha_api_name      = "alpha-api"
  beta_api_name       = "beta-api"
  alpha_api_path      = "alpha"
  beta_api_path       = "beta"
  default_root_object = "index.html"
  s3_origin_id        = "s3-root-origin"
  auth_header_name    = "X-Custom-Auth-Header"
  api_target_header_name    = "X-Api-Target"
}
