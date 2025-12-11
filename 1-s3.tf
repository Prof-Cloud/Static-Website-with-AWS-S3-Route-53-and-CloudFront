#Creating S3 bucket
resource "aws_s3_bucket" "S3_bucket" {
  bucket = var.bucket_name


  tags = {
    Name = "S3 Robot"
  }
  #Allow terraform to delete the bucket even if files exist in the bucket
  force_destroy = true
}

#Enabling bucket or no rules automatically
resource "aws_s3_bucket_ownership_controls" "Drop_off_ownership" {
  bucket = aws_s3_bucket.S3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#Making S3 bucket private
resource "aws_s3_bucket_public_access_block" "access_S3Robot" {
  bucket                  = aws_s3_bucket.S3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Enabling versioning
resource "aws_s3_bucket_versioning" "S3Robot_versioning" {
  bucket = aws_s3_bucket.S3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "S3Robot-lifecycle" {
  bucket = aws_s3_bucket.S3_bucket.id

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
