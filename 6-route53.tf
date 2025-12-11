#Creating DNS record on Route 53

resource "aws_route53_record" "www" {

#"for each" loops over all validation options to create a DNS record for each one
#Each domain (main + subdomains/wildcards) will have a validation option 
# getvanish.io, or any www.getvanish.io or *.getvanish.io
for_each = {for dvo in aws_acm_certificate.cert.domain_valudation_options}

  zone_id = aws_route53_zone.primary.zone_id
  name    = dvo.resource_record_name #e.g. *.getvanish.io
  type    = dvo.resource_record_type #CNAME 
  records = dvo.resource_record_value # value provided by ACM
}

#Route 53 alias record for the root domain

resource "aws_route53_record" "root_alias" {

    zone_id = aws_route53_zone.primary.zone_id
name = var.domain_name
type = "A"

#Always use alias for CloudFront distribution, AWS handles IPs dynamically
alias {
  #CloudFront distribution DNS name
  name = aws_cloudfront_distribution.s3_distribution.domain_name
  zone_id = aws_cloudfront_distribution.s3_distribution.zone_id
  evaluate_target_health = false 

}
}
