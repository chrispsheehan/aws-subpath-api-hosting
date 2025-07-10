output "api_domain_name" {
  value = replace(
    replace(aws_apigatewayv2_stage.this.invoke_url, "https://", ""),
    "/${aws_apigatewayv2_stage.this.name}",
    ""
  )
}

output "api_stage" {
  value = aws_apigatewayv2_stage.this.name
}
