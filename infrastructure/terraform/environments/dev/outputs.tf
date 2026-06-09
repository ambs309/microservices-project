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

output "ec2_instance_profile_name" {
  value = module.iam.ec2_instance_profile_name
}

output "ec2_role_name" {
  value = module.iam.ec2_role_name
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_public_dns" {
  value = module.ec2.public_dns
}

output "app_security_group_id" {
  value = module.ec2.security_group_id
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_name" {
  value = module.rds.db_name
}
