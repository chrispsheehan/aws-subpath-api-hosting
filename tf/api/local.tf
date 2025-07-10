locals {
  lambda_runtime = "nodejs18.x"
  lambda_name    = "${var.api_stage}-${var.api_name}"
}
