#Cloudfront 

#Creating an Origin Acess Control (OAC)
#Used by Cloudfront to sign requests to S3 with SigV4
resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = "S3 OAC"
  description                       = "OAC for private S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#Cloudfront distribution for static website
#Attach OAC to the orgin

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.S3_bucket.bucket_regional_domain_name
    origin_id   = "s3_origin"

    #Note must be outside s3_origin_config
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
  }

  #Cache 
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_origin"

    #redirect to HTTPS
    viewer_protocol_policy = "redirect-to-https"

    #Required by cloudfront
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  #Price Class
  #Controls where Cloudfront distributes your content

  price_class = "PriceClass_100" #Cheapest - Only US, Canada and, Europe

  #Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none" #No geoblocking
    }
  }

  #Viewer Certificate
  #Required
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}
