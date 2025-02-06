// File: modules/iam/main.tf
// ---------------------------------------------------------------------------
// Generic IAM Module for wiz-tasky Project
// This module creates an IAM role and attaches policies based on input parameters.
// It supports attaching managed policies (via managed_policy_arns) and an inline policy
// whose JSON is loaded from an external file (if inline_policy_file is provided).
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
  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "managed_attachment" {
  for_each   = var.managed_policy_arns
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

// Read the inline policy from a file if provided
data "local_file" "inline_policy" {
  count    = length(trimspace(var.inline_policy_file)) > 0 ? 1 : 0
  filename = var.inline_policy_file
}

resource "aws_iam_role_policy" "inline_policy" {
  count  = length(data.local_file.inline_policy) > 0 ? 1 : 0
  name   = "${var.role_name}-custom-policy"
  role   = aws_iam_role.role.name
  policy = data.local_file.inline_policy[0].content
}
