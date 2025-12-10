#Creating S3 bucket
resource "aws_s3_bucket" "S3Robot" {
  bucket = "S3Robot"


  tags = {
    Name        = "S3 Robot"
  }
  #Allow terraform to delete the bucket even if files exist in the bucket
  force_destroy = true
}

#Enabling bucket or no rules automatically
resource "aws_s3_bucket_ownership_controls" "Drop_off_ownership" {
  bucket = aws_s3_bucket.S3Robot.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#Blocks all public access
resource "aws_s3_bucket_public_access_block" "access_S3Robot" {
  bucket                  = aws_s3_bucket.S3Robot.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Enabling versioning
resource "aws_s3_bucket_versioning" "S3Robot_versioning" {
  bucket = aws_s3_bucket.S3Robot.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "S3Robot-lifecycle" {
  bucket = aws_s3_bucket.S3Robot.id

  rule {
    id = "Lifecycle rules"

    expiration {
      days = 90
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}
