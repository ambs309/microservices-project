locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "budget" {
  source = "../../modules/budget"

  project_name                 = var.project_name
  environment                  = var.environment
  billing_email                = var.billing_email
  monthly_budget_limit_usd     = var.monthly_budget_limit_usd
  budget_warning_threshold_usd = var.budget_warning_threshold_usd
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "sqs" {
  source = "../../modules/sqs"

  name_prefix = local.name_prefix
}

module "iam" {
  source = "../../modules/iam"

  name_prefix           = local.name_prefix
  sqs_queue_arn         = module.sqs.product_events_queue_arn
  dead_letter_queue_arn = module.sqs.dead_letter_queue_arn
}

module "ec2" {
  source = "../../modules/ec2"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  instance_profile_name = module.iam.ec2_instance_profile_name
  allowed_ssh_cidr      = var.allowed_ssh_cidr
  key_name              = var.ec2_key_name
  instance_type         = var.ec2_instance_type
}

module "rds" {
  source = "../../modules/rds"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  allowed_security_group_ids = [module.ec2.security_group_id]
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
}
