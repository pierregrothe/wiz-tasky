// File: modules/iam/main.tf
// ---------------------------------------------------------------------------
// Generic IAM Module for wiz-tasky Project
// Creates an IAM role with dynamic naming based on the project, environment, and role type.
// It attaches managed policies and, if provided, an inline policy loaded from an external file.
// ---------------------------------------------------------------------------

locals {
  // Compute a dynamic role name.
  computed_role_name = "${var.project_name}-${var.environment_name}-${var.role_type}-role"

  // Merge base tags with additional identification tags.
  merged_tags = merge(
    var.tags,
    {
      project     = var.project_name,
      environment = var.environment_name,
      role        = var.role_type
    }
  )
}

resource "aws_iam_role" "role" {
  name               = local.computed_role_name
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

// Attach managed policies.
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

// Conditionally create an inline policy.
resource "aws_iam_role_policy" "inline_policy" {
  count  = length(data.local_file.inline_policy) > 0 ? 1 : 0
  name   = "${aws_iam_role.role.name}-custom-policy"
  role   = aws_iam_role.role.name
  policy = data.local_file.inline_policy[0].content
}
