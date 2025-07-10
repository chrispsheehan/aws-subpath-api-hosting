output "domain_url" {
  value = "https://${aws_cloudfront_distribution.this.domain_name}"
}

output "static_bucket_name" {
  value = aws_s3_bucket.website_files.bucket
}
