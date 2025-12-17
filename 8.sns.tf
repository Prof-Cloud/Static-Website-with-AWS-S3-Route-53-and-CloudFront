#Create an SNS Topic to send alerts
resource "aws_sns_topic" "alerts" {
  name = "website-alerts"
}
##Add  email alert
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol = "email"
  endpoint = "the.fire.dragon.mac@gmail.com" #add your emaul
}
