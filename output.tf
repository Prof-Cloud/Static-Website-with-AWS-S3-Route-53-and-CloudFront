output "s3_bucket_website_url" {
  value = aws_s3_bucket_website_configuration.S3Robot_Website.website_endpoint
}