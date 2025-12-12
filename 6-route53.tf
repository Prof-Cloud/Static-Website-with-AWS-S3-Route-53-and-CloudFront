#Route53 Hosted Zone
#Created a new hosted Zone for my domain

resource "aws_route53_zone" "primary" {
  name = var.domain_name   
}

#Update the registrar
resource "aws_route53domains_registered_domain" "registrar" {
  
  domain_name = var.domain_name

  # Loop over the four nameservers created by the hosted zone
  dynamic "name_server" {
    for_each = aws_route53_zone.primary.name_servers
    content {
      name = name_server.value
    }
}
  auto_renew = true 
  registrant_privacy = true 
  
  # Ensure the zone is created before we try to use its nameservers
  depends_on = [aws_route53_zone.primary]
}


#Creating DNS record on Route53 
resource "aws_route53_record" "cert" {

  #"for each" loops over all validation options to create a DNS record for each one
  #Each domain (main + subdomains/wildcards) will have a validation option 
  # getvanish.io, or any www.getvanish.io or *.getvanish.io
  for_each = { for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => dvo }

  #Reference the zone ID
  zone_id = aws_route53_zone.primary.id

  name    = each.value.resource_record_name #e.g. *.getvanish.io
  type    = each.value.resource_record_type #CNAME 
  ttl     = 60
  records = [each.value.resource_record_value] # value provided by ACM
}

#This resource block execution will certification status is "issued"
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}

#Route 53 alias record for the root domain
#Pints domain to Cloudfront 
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