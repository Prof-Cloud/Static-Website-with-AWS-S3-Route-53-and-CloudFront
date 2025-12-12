#Requesting SSL certificate for CloudFront
#cert on available in us-east-01

resource "aws_acm_certificate" "cert" {
  #provider = aws.acm_provider
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "Cloudfront SSL Cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}