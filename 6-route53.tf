#Route53 Hosted Zone
#I have an existing hosted zone

data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}

#Creating DNS record on Route53 

resource "aws_route53_record" "cert" {

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.primary.zone_id
  ttl             = var.dns_record_ttl

  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type

}

#Route 53 alias record for the root domain
#Pints domain to Cloudfront 
resource "aws_route53_record" "root_alias" {

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  #Always use alias for CloudFront distribution, AWS handles IPs dynamically
  alias {
    #CloudFront distribution DNS name
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false

  }
}

#Wait for ACM validation
resource "aws_acm_certificate_validation" "cert_validation" {
  #References the cert you requested
  certificate_arn = aws_acm_certificate.cert.arn

  #References the Route53 validation records
  validation_record_fqdns = [aws_route53_record.cert.fqdn]

/*Add a dependency to ensure the Route 53 records are create first*/
depends_on = [aws_route53_record.cert]
  
}