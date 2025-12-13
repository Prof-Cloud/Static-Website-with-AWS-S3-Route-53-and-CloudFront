#Domain name
variable "bucket_name" {
  default = "profclouds3"
}

#Domain name
variable "domain_name" {
  default = "getvanish.io"
}

#IAM Policy document that allows CLoudFront to acess objects in the S3 bucket

data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.S3_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

variable "dns_record_ttl" {
  default     = 600
  type        = number
  description = "TTL for DNS records"
}