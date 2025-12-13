#Requesting SSL certificate for CloudFront
#cert on available in us-east-01

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name = "Cloudfront SSL Cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}