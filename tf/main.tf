resource "aws_s3_bucket" "lambda_bucket" {
  bucket = local.lambda_bucket
}

resource "aws_s3_object" "lambda_zip" {
  bucket        = aws_s3_bucket.lambda_bucket.id
  key           = basename(var.lambda_zip_path)
  source        = var.lambda_zip_path
  force_destroy = true
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${local.lambda_name}-iam"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "lambda" {
  depends_on = [aws_s3_object.lambda_zip]

  function_name = local.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.handler"
  runtime       = local.lambda_runtime

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = aws_s3_object.lambda_zip.key
}

resource "aws_lambda_permission" "this" {
  statement_id  = "${local.lambda_name}-AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_stage.this.execution_arn}/*"
}

resource "aws_apigatewayv2_api" "this" {
  name          = "${local.lambda_name}-APIGateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.function_stage
  auto_deploy = true
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

resource "aws_s3_bucket_policy" "website_files_policy" {
  bucket = aws_s3_bucket.website_files.id
  policy = data.aws_iam_policy_document.website_files_policy.json
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-${local.domain}"
  description                       = "OAC Policy for ${local.domain}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  # Origin for the root of the S3 bucket
  origin {
    domain_name              = aws_s3_bucket.website_files.bucket_regional_domain_name
    origin_id                = "root-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # Origin for /client1
  origin {
    domain_name              = aws_s3_bucket.website_files.bucket_regional_domain_name
    origin_id                = "client1-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_path              = "/client1"
  }

  # Origin for /client2
  origin {
    domain_name              = aws_s3_bucket.website_files.bucket_regional_domain_name
    origin_id                = "client2-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_path              = "/client2"
  }

  # Origin for the API Gateway
  origin {
    domain_name = replace(
      replace(aws_apigatewayv2_stage.this.invoke_url, "https://", ""),
      "/${aws_apigatewayv2_stage.this.name}",
      ""
    )
    origin_id   = local.api_domain
    origin_path = "/${aws_apigatewayv2_stage.this.name}"

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
    target_origin_id       = "root-origin"
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

  default_root_object = local.default_root_object

  # Custom error response for access denied
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = local.default_root_object
  }

  # Custom error response for not found
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = local.default_root_object
    error_caching_min_ttl = 300
  }

  # Cache behavior for /client1
  ordered_cache_behavior {
    path_pattern           = "/client1/*"
    target_origin_id       = "client1-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress    = true
  }

  # Cache behavior for /client2
  ordered_cache_behavior {
    path_pattern           = "/client2/*"
    target_origin_id       = "client2-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress    = true
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
    default_ttl = 3600
    max_ttl     = 86400
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

