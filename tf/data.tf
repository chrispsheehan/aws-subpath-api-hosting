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

data "aws_iam_policy_document" "website_files_policy" {
  statement {
    sid     = "AllowPublic"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = ["${aws_s3_bucket.website_files.arn}/*"]
  }

  statement {
    sid     = "DenyUnlessAuthHeader"
    effect  = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_files.arn}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestHeader/${local.auth_header_name}"
      values   = ["${aws_ssm_parameter.api_key_ssm.value}"]
    }
  }
}
