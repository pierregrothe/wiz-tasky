// File: modules/iam/main.tf
// ---------------------------------------------------------------------------
// IAM Module for wiz-tasky Project
// This module creates an IAM role with an attached policy.
// The policy document is generated based on the "remediation_mode" variable:
//   - When remediation_mode is false (misconfigured), the policy allows ec2:* (overly permissive).
//   - When remediation_mode is true (remediated), the policy is restricted to least privilege,
//     for example, only allowing ec2:DescribeInstances.
// ---------------------------------------------------------------------------

resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = var.assumed_by_service  // e.g., "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.merged_tags, // Merged tags defined in tags.tf
    { component = "iam-role" }
  )
}

locals {
  policy_document = var.remediation_mode ? jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:DescribeInstances" // Least privilege in remediated mode
        ],
        Resource = "*"
      }
    ]
  }) : jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:*",  // Overly permissive in misconfigured mode
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "${var.role_name}-policy"
  description = "Policy for ${var.role_name} role. Uses remediation_mode to toggle between misconfigured and secure policies."
  policy      = local.policy_document
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
