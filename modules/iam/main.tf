// File: modules/iam/main.tf
// ---------------------------------------------------------------------------
// IAM Module for wiz-tasky Project
// This module creates an IAM role with an attached policy.
// The policy is defined based on the "assessment_mode" variable:
//   - If assessment_mode is true, an overly permissive policy (e.g., "ec2:*")
//     is attached to the role.
//   - If assessment_mode is false, a restricted, least-privilege policy is attached.
// ---------------------------------------------------------------------------

# Create the IAM role with a trust policy that allows an AWS service to assume it.
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

# Define a local variable for the policy document.
locals {
  policy_document = var.assessment_mode ? jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:*",  // Overly permissive policy for assessment
        Resource = "*"
      }
    ]
  }) : jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create the IAM policy using the policy document.
resource "aws_iam_policy" "policy" {
  name        = "${var.role_name}-policy"
  description = "Policy for ${var.role_name} role. Overly permissive if in assessment mode; otherwise, least privilege."
  policy      = local.policy_document
}

# Attach the policy to the IAM role.
resource "aws_iam_role_policy_attachment" "role_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
