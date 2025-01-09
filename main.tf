locals {
  name_prefix = split("/", "${data.aws_caller_identity.current.arn}")[1]
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "${local.name_prefix}-tf-info-count-breach"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "info-count"
  namespace                 = "/moviedb-api/${local.name_prefix}"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 10
#   alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.topic.arn]  
}

resource "aws_sns_topic" "topic" {
  name = "${local.name_prefix}-alert-topic"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "${local.name_prefix}@gmail.com"
}