variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "cis-final-project"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "eu-central-1"
}

variable "billing_email" {
  description = "Email address used for AWS budget notifications."
  type        = string
}

variable "monthly_budget_limit_usd" {
  description = "Maximum tolerated monthly project cost in USD."
  type        = number
  default     = 20
}

variable "budget_warning_threshold_usd" {
  description = "Warning threshold for billing alarm in USD."
  type        = number
  default     = 5
}
