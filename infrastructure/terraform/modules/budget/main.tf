resource "aws_budgets_budget" "project_budget" {
  name         = "${var.project_name}-${var.environment}-budget"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.budget_warning_threshold_usd
    threshold_type             = "ABSOLUTE_VALUE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.billing_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = var.monthly_budget_limit_usd
    threshold_type             = "ABSOLUTE_VALUE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.billing_email]
  }
}
