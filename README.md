# Static Website with AWS S3, Route 53, and CloudFront

In this project, I built a highly secure and scalable static website for the domain "getvanish.io" using AWS. I created the entire infrastructure using Terraform. I used a private S3 bucket, a Cloudfront distribution, an SNS topic, a Route 53 DNS, and Cloudwatch. To ensure the site was production-ready, I implemented an SSL certificate for HTTPS and used Origin Access Control (OAC) to keep the S3 bucket hidden from the public internet. Additionally, integrating CloudWatch Alarms and SNS allows me to receive alerts via email if users start encountering error pages, ensuring I can monitor the site's health in real-time.


<img width="4518" height="1943" alt="Blank diagram (1)" src="https://github.com/user-attachments/assets/dedef41a-8625-4d69-bfca-3990d7f2a916" />


## Highlighting the Important Features

1. Private S3 bucket - I created an S3 bucket to host the static website files, but kept it completely private by blocking ALL public access.

2. CloudFront Distribution (CDN)  - I used CloudFront to serve the website
     - Redirects HTTP to HTTPS so the connection is always encrypted
     - Custom Error Handling where 404/4-3 errors are redirected to a custom error.html   page
  
3. Origin Access Control (OAC) - I set up OAC so CloudFront can securely fetch files from the private S3 bucket. 

4. Route 53 & ACM - I managed the DNS for "getvanish.io" using Route 53
     - A-record (Alias) to point the root domain to the CloudFront DNS.
     - ACM certificate
       
5. CloudWatch Alarms & SNS - I created a monitoring system to catch issues:
     - Metric Alarms that watch for spikes in 404 or 403 error rates
     - SNS Topic that sends an automated email alert to my inbox if the website is down or showing the error page to users
   


## Improvements I Can Add Later

1. AWS WAF (Web Application Firewall) - Attach a WAF to CloudFront to block bot traffic and block common attack patterns such as SQL injection or cross-site scripting (XSS).

2.  Lambda@Edge - Use serverless functions to modify headers or perfomr security checks at the edge locations

3.  Multi-Region Failover - Set up a secondary S3 bucket in a different region in case of AWS regional outage.
