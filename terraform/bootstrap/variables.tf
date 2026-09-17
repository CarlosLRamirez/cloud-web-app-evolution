variable "aws_region" {
  description = "AWS region where the Terraform state backend is created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used to name the state bucket and lock table."
  type        = string
  default     = "brewops"
}

variable "aws_profile" {
  description = "Named AWS CLI profile (e.g. from `aws configure sso`) used to authenticate."
  type        = string
  default     = "brewops-admin"
}

variable "environment" {
  description = "Value for the Environment tag required (alongside Project) by the org's tagging SCP on resource-creation calls."
  type        = string
  default     = "dev"
}
