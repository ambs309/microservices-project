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
