#Domain name
variable "bucket_name" {
  type        = string
  description = "S3Robot"
}

#Domain name
variable "domain_name" {
  type        = string
  description = "getvanish.io"
}

#IAM Policy document that allows CLoudFront to acess objects in the S3 bucket

data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.S3_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.web.iam_arn]
    }
  }
}