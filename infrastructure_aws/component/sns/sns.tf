resource "aws_sns_topic" "sns_topic" {
  count = "${var.count}"
  name = "${var.environment}_sns_topic"
}