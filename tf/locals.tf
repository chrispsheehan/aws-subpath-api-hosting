locals {
  lambda_runtime      = "nodejs18.x"
  lambda_name         = "${var.function_stage}-${var.function_name}"
  lambda_bucket       = "${local.lambda_name}-bucket"
  domain              = local.lambda_name
  api_domain          = "${local.lambda_name}-api"
  default_root_object = "index.html"
  s3_origin_id        = "s3-root-origin"
}
