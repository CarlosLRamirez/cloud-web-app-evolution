data "terraform_remote_state" "landing_zone" {
  backend = "s3"

  config = merge(
    {
      bucket  = var.landing_zone_state_bucket
      key     = var.landing_zone_state_key
      region  = var.landing_zone_state_region
      profile = var.aws_profile
    },
    # Only set when the landing zone's state bucket lives in a different
    # AWS account than this workload (see Fase 1 runbook, Paso 2).
    # Terraform >= 1.11 nests this under assume_role instead of a flat
    # role_arn key.
    var.landing_zone_state_role_arn == null ? {} : {
      assume_role = {
        role_arn = var.landing_zone_state_role_arn
      }
    }
  )
}
