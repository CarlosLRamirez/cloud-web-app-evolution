variable "landing_zone_state_bucket" {
  description = "S3 bucket holding the landing zone repo's Terraform state. No default on purpose — set it in a gitignored terraform.tfvars, since the bucket name identifies the AWS account it lives in."
  type        = string
}

variable "landing_zone_state_key" {
  description = "Key (path) of the landing zone state object within that bucket."
  type        = string
  default     = "landing-zone/terraform.tfstate"
}

variable "landing_zone_state_region" {
  description = "AWS region of the landing zone state bucket."
  type        = string
  default     = "us-east-1"
}

variable "landing_zone_state_role_arn" {
  description = "IAM role to assume when reading the landing zone's state, if its bucket lives in a different AWS account (see Fase 1 runbook, Paso 2). Leave null to read it with this workload's own credentials."
  type        = string
  default     = null
}

variable "aws_profile" {
  description = "Named AWS CLI profile (e.g. from `aws configure sso`) used to authenticate."
  type        = string
  default     = "brewops-admin"
}

variable "aws_region" {
  description = "AWS region where BrewOps' Phase 1 infrastructure is created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Value for the Project tag (also required by the org's tagging SCP on some resource types)."
  type        = string
  default     = "brewops"
}

variable "environment" {
  description = "Value for the Environment tag (also required by the org's tagging SCP on some resource types)."
  type        = string
  default     = "dev"
}

variable "operator_ip" {
  description = "Your public IP address (no /32 suffix), allowed for SSH access to the EC2 instance. No default on purpose — it's personal/identifying, set it in a gitignored terraform.tfvars."
  type        = string
}

variable "app_port" {
  description = "TCP port the BrewOps app listens on, exposed publicly."
  type        = number
  default     = 3000
}
