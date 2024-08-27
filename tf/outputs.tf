output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.this.domain_name}"
}

output "api_gateway_url" {
  value = aws_apigatewayv2_stage.this.invoke_url
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}
