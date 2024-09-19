output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.this.domain_name}"
}

output "cloudfront_dist_id" {
  value = aws_cloudfront_distribution.this.id
}

output "api_gateway_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "static_s3_bucket" {
  value = aws_s3_bucket.static_bucket.bucket
}
