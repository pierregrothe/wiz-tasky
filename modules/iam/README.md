# IAM Module for wiz-tasky Project

This module creates an IAM role along with an attached policy. The policy attached to the role depends on the `assessment_mode` variable:
- **Assessment Mode (true):** An overly permissive policy (e.g., allowing `ec2:*`) is attached to demonstrate misconfiguration.
- **Remediated Mode (false):** A least-privilege policy is attached, limiting the actions to only what is necessary (e.g., `ec2:DescribeInstances`, `ec2:StartInstances`, `ec2:StopInstances`).

## Inputs

- **role_name:** The name for the IAM role.
- **assumed_by_service:** The AWS service allowed to assume this role (default: `ec2.amazonaws.com`).
- **assessment_mode:** Boolean toggle to determine whether the role gets an overly permissive policy (true) or a least-privilege policy (false).
- **tags:** Base tags to apply to the IAM role.
- **project_name:** Project name for consistent resource naming.
- **environment_name:** Deployment environment (e.g., dev, staging, prod).

## Outputs

- **role_arn:** The ARN of the created IAM role, which can be referenced by other modules.

## Usage Example

```hcl
module "iam" {
  source            = "./modules/iam"
  role_name         = "wiz-tasky-mongodb-role"
  assessment_mode   = var.assessment_mode
  tags              = local.all_tags
  project_name      = var.project
  environment_name  = var.environment
}
