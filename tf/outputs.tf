output "domain_url" {
  value = "https://${aws_cloudfront_distribution.ui.domain_name}"
}

output "static_bucket_name" {
  value = aws_s3_bucket.website_files.bucket
}

output "ui_dist_id" {
  value = aws_cloudfront_distribution.ui.id
}

output "api_dist_id" {
  value = aws_cloudfront_distribution.api_domain.id
}
