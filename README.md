# Static Website with AWS S3, Route 53, and CloudFront

In this project, I built a highly secure and scalable static website for the domain getvanish.io using AWS. I created the entire infrastructure using Terraform. I used a private S3 bucket, a Cloudfront distribution, an SNS topic, a Route 53 DNS, and Cloudwatch. To ensure the site was production-ready, I implemented an SSL certificate for HTTPS and used Origin Access Control (OAC) to keep the S3 bucket hidden from the public internet. Also, integrating CloudWatch Alarms and SNS to alert me via email if users start hitting error pages, ensuring I can monitor the site's health in realtime.

## Highlighting the Important Features


## Improvements I Can Add Later
1. AWS WAF (Web Application Firewall) - Attach a WAF to CloudFront to block bot traffic and block common attack patterns such as SQL injection or cross-site scripting (XSS).

2.  Lambda@Edge - Use serverless functions to modify headers or perfomr security checks at the edge locations

3.  Multi-Region Failover - Set up a secondary S3 bucket in a different region in case of AWS regional outage.
