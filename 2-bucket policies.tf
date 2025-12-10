resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.S3Robot.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Statement1"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = [
          "arn:aws:s3:::S3Robot/*"
        ]
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.access_S3Robot]
}