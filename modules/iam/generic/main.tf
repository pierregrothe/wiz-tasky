// File: modules/iam/generic/main.tf
// ---------------------------------------------------------------------------
// Generic IAM Module for wiz-tasky Project
// This module creates an IAM role and attaches both custom and managed policies
// based on input parameters. It is designed to be reused for different tiers,
// such as Bastion and MongoDB.
// ---------------------------------------------------------------------------

resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = var.assumed_by_service
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(var.tags, {
    project     = var.project_name,
    environment = var.environment_name,
    role_type   = var.role_type
  })
}

# Attach custom policies.
resource "aws_iam_role_policy_attachment" "custom_attachment" {
  for_each = var.custom_policy_arns
  role     = aws_iam_role.role.name
  policy_arn = each.value
}

# Attach managed policies.
resource "aws_iam_role_policy_attachment" "managed_attachment" {
  for_each = var.managed_policy_arns
  role     = aws_iam_role.role.name
  policy_arn = each.value
}
