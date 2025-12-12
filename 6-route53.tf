#Route 54 Host Zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

#Creating DNS record on Route 53
resource "aws_route53_record" "cert" {

  #"for each" loops over all validation options to create a DNS record for each one
  #Each domain (main + subdomains/wildcards) will have a validation option 
  # getvanish.io, or any www.getvanish.io or *.getvanish.io
  for_each = { for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => dvo }

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.resource_record_name #e.g. *.getvanish.io
  type    = each.value.resource_record_type #CNAME 
  ttl     = 60
  records = [each.value.resource_record_value] # value provided by ACM
}


#Route 53 alias record for the root domain

resource "aws_route53_record" "root_alias" {

  zone_id = aws_route53_zone.primary.zone_id
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
