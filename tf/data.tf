data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# data "aws_iam_policy_document" "website_files_policy" {

#   version = "2012-10-17"
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.website_files.arn}/*"]

#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     condition {
#       test     = "StringLike"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.this.arn]
#     }
#   }
# }

data "aws_iam_policy_document" "website_files_policy" {
  version = "2012-10-17"
  
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_files.arn}/*"]

    # Allowing access to any principal (completely open to the public)
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
