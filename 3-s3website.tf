resource "aws_s3_bucket_website_configuration" "S3Robot_Website" {
  bucket = aws_s3_bucket.S3_bucket.id

  index_document {
    suffix = "StaticWebsite.html"
  }
  error_document {
    key = "error.html"
  }
}
