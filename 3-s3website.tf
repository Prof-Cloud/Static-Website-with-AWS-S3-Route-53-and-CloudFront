resource "aws_s3_bucket_website_configuration" "S3Robot_Website" {
  bucket = aws_s3_bucket.S3Robot.id

  index_document {
    suffix = "StaticWebsite.html"
  }
}
