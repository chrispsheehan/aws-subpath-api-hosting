locals {
  domain                  = "aws-subpath-api-hosting"
  lambda_code_bucket      = "${data.aws_caller_identity.current.account_id}-${local.domain}-lambda-code-bucket"
  static_web_files_bucket = "${data.aws_caller_identity.current.account_id}-${local.domain}"
  default_root_object     = "index.html"
  s3_origin_id            = "s3-root-origin"
  auth_header_name        = "X-Custom-Auth-Header"

  api_base_path     = "api"
  alpha_api_name    = "${local.api_base_path}-alpha"
  proxy_path_prefix = "proxy"
}
