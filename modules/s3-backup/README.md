# S3 Backup Module for wiz-tasky Project

This module provisions an S3 bucket intended for database backups. The bucket policy is configured based on the `remediation_mode` variable:
- **Misconfigured (remediation_mode = false):** The bucket policy allows public read access.
- **Remediated (remediation_mode = true):** The bucket policy denies public access, ensuring the bucket is secured.

## Inputs

- **bucket_name:** The name of the S3 bucket.
- **remediation_mode:** Boolean toggle for secure (true) or misconfigured (false) configuration.
- **tags:** Base tags to apply to the bucket.
- **project_name:** Project name for consistent naming.
- **environment_name:** Deployment environment (e.g., dev, staging, prod).

## Outputs

- **bucket_name:** The name of the S3 backup bucket.
- **bucket_arn:** The ARN of the S3 backup bucket.

## Usage Example

```hcl
module "s3_backup" {
  source           = "./modules/s3-backup"
  bucket_name      = "wiz-tasky-backups-${var.environment}"
  remediation_mode = var.remediation_mode
  tags             = local.all_tags
  project_name     = var.project
  environment_name = var.environment
}
