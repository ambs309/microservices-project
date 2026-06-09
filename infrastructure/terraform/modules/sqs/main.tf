resource "aws_sqs_queue" "dead_letter_queue" {
  name                      = "${var.name_prefix}-product-events-dlq"
  message_retention_seconds = var.message_retention_seconds

  tags = {
    Name = "${var.name_prefix}-product-events-dlq"
  }
}

resource "aws_sqs_queue" "product_events" {
  name                       = "${var.name_prefix}-product-events"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = {
    Name = "${var.name_prefix}-product-events"
  }
}
