resource "aws_sns_topic" "contact_form_topic" {
  name = "ContactFormTopic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.contact_form_topic.arn
  protocol  = "email"
  endpoint  = var.contact_email
}