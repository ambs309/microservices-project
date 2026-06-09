output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "product_events_queue_url" {
  value = module.sqs.product_events_queue_url
}

output "product_events_queue_arn" {
  value = module.sqs.product_events_queue_arn
}

output "dead_letter_queue_url" {
  value = module.sqs.dead_letter_queue_url
}

output "dead_letter_queue_arn" {
  value = module.sqs.dead_letter_queue_arn
}
