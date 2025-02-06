# Generic IAM Module for wiz-tasky Project

This module creates an IAM role with attached policies based on input parameters. It is designed to be reused across multiple tiers (e.g., Bastion, MongoDB, EKS) by passing in:
- A custom role name.
- The AWS service that will assume the role.
- Maps of custom and managed policy ARNs.
- Base tags, project, and environment details.

## Inputs

- **role_name:** The name for the IAM role.
- **assumed_by_service:** The AWS service allowed to assume this role (default: ec2.amazonaws.com).
- **custom_policy_arns:** A map of custom policy ARNs to attach.
- **managed_policy_arns:** A map of managed policy ARNs to attach (e.g., AmazonSSMManagedInstanceCore).
- **tags:** Base tags to apply to the IAM role.
- **project_name:** Project name.
- **environment_name:** Deployment environment (e.g., dev, staging, prod).
- **role_type:** A label for the role (e.g., "bastion", "mongodb").

## Outputs

- **role_arn:** The ARN of the created IAM role.
- **role_name:** The name of the created IAM role.

## Usage Example

```hcl
module "iam_bastion" {
  source            = "./modules/iam/generic"
  role_name         = "wiz-tasky-bastion-role"
  remediation_mode  = false  # (if you want to pass a flag in custom logic, or include it in the policy ARNs map)
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  custom_policy_arns = {}
  tags              = local.all_tags
  project_name      = var.project
  environment_name  = var.environment
  role_type         = "bastion"
}

module "iam_mongodb" {
  source            = "./modules/iam/generic"
  role_name         = "wiz-tasky-mongodb-role"
  managed_policy_arns = {
    ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  custom_policy_arns = {
    custom = var.remediation_mode ? "arn:aws:iam::591021320707:policy/mongodb-remediated" : "arn:aws:iam::591021320707:policy/mongodb-misconfigured"
  }
  tags              = local.all_tags
  project_name      = var.project
  environment_name  = var.environment
  role_type         = "mongodb"
}
