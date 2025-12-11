#S3 bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket     = aws_s3_bucket.S3_bucket.id
  policy     = data.aws_iam_policy_document.s3_cloudfront_policy.json
  depends_on = [aws_s3_bucket_public_access_block.access_S3Robot]
}
