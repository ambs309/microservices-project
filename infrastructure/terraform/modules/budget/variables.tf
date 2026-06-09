variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "billing_email" {
  type = string
}

variable "monthly_budget_limit_usd" {
  type = number
}

variable "budget_warning_threshold_usd" {
  type = number
}
