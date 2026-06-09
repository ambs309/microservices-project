output "product_events_queue_name" {
  value = aws_sqs_queue.product_events.name
}

output "product_events_queue_url" {
  value = aws_sqs_queue.product_events.url
}

output "product_events_queue_arn" {
  value = aws_sqs_queue.product_events.arn
}

output "dead_letter_queue_name" {
  value = aws_sqs_queue.dead_letter_queue.name
}

output "dead_letter_queue_url" {
  value = aws_sqs_queue.dead_letter_queue.url
}

output "dead_letter_queue_arn" {
  value = aws_sqs_queue.dead_letter_queue.arn
}
