resource "aws_s3_bucket" "lambda_bucket" {
  bucket = local.lambda_code_bucket
}

resource "aws_s3_object" "lambda_zip" {
  bucket        = aws_s3_bucket.lambda_bucket.id
  key           = basename(var.lambda_zip_path)
  source        = var.lambda_zip_path
  force_destroy = true
}

module "api_alpha" {
  source = "./api"

  api_name              = local.alpha_api_name
  api_stage             = var.function_stage
  lambda_code_bucket    = aws_s3_bucket.lambda_bucket.bucket
  lambda_code_s3_object = aws_s3_object.lambda_zip.key
}

module "api_beta" {
  source = "./api"

  api_name              = local.beta_api_name
  api_stage             = var.function_stage
  lambda_code_bucket    = aws_s3_bucket.lambda_bucket.bucket
  lambda_code_s3_object = aws_s3_object.lambda_zip.key
}

resource "aws_s3_bucket" "website_files" {
  bucket        = local.domain
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "website_files" {
  depends_on = [aws_s3_bucket.website_files]
  bucket     = aws_s3_bucket.website_files.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.website_files.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_files_policy" {
  depends_on = [aws_s3_bucket.website_files, aws_s3_bucket_public_access_block.this]
  bucket     = aws_s3_bucket.website_files.id
  policy     = data.aws_iam_policy_document.website_files_policy.json
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.website_files.bucket

  index_document {
    suffix = local.default_root_object
  }
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = local.s3_origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Origin for the Alpha API Gateway
  origin {
    domain_name = module.api_alpha.api_domain_name
    origin_id   = local.alpha_api_name
    origin_path = "/${module.api_alpha.api_stage}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  origin {
    domain_name = module.api_beta.api_domain_name
    origin_id   = local.beta_api_name
    origin_path = "/${module.api_beta.api_stage}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  # Default Cache Behavior - Serve from root of the S3 bucket
  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress    = true
  }

  # Custom error response for access denied
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/403.html"
    # response_page_path    = "/client1/index.html"
  }

  # Custom error response for not found
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 0
  }

  # Ordered cache behavior for API requests
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = local.api_domain
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
    compress    = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
