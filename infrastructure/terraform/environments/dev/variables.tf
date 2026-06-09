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

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones used by the VPC."
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "db_name" {
  description = "Application database name."
  type        = string
  default     = "microservices"
}

variable "db_username" {
  description = "Application database username."
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Application database password."
  type        = string
  sensitive   = true
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to access the EC2 instance by SSH."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ec2_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}
