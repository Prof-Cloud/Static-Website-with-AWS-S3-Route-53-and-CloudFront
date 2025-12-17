
##CloudWatch Alarm 
resource "aws_cloudwatch_metric_alarm" "error_4xx" {
  alarm_name = "4xx-Error"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "TotalErrorRate" #Monitor all 4xx error
  namespace = "AWS/CloudFront"
  period = "60"
  statistic = "Average"
  threshold = "10" ##Alert if >10% pf requests are errors
  alarm_description = "This alarm fires if the CloudWatch error rate is too high"

#Connecting to SNS topic
dimensions = {
    distributionID = aws_cloudfront_distribution.s3_distribution.id 
    region = "Global"
}

alarm_actions = [aws_sns_topic.alerts.arn]
}

##CloudWatch Alarm - Email alert
resource "aws_cloudwatch_metric_alarm" "error_page_alert" {
  alarm_name = "Website-Showing-Error-Page"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1" #Trigger quickly
  metric_name = "404ErrorRate" #Specifically monitors "Not Found"
  namespace = "AWS/CloudFront"
  period = "10" 
  statistic = "Average"
  threshold = "5" ##Alert if >5% of traffic hits error.html
  alarm_description = "Email alert when users are seeing the error.html page"

#Connect to SNS topic from earlier 
alarm_actions = [aws_sns_topic.alerts.arn]

dimensions = {
    distributionID = aws_cloudfront_distribution.s3_distribution.id 
    region = "Global"
}
}