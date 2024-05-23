resource "aws_cloudwatch_log_group" "log_group-web" {
  name              = "${var.web-prefix}-container-logs"
  retention_in_days = var.retention_in_days

   tags = {
    Name = "${var.web-prefix}-container-logs"
    Owner = var.owner-tag
  }
}

resource "aws_cloudwatch_log_group" "log_group-app" {
  name              = "${var.app-prefix}-container-logs"
  retention_in_days = var.retention_in_days

   tags = {
    Name = "${var.app-prefix}-container-logs"
    Owner = var.owner-tag
  }
}