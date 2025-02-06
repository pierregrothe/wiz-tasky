// File: modules/iam/main.tf
// ---------------------------------------------------------------------------
// IAM Module for wiz-tasky Project
// This module creates an IAM role and attaches policies based on the provided
// parameters. It uses local.merged_tags (defined in tags.tf) to apply consistent
// tagging across all IAM resources.
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

resource "aws_iam_role_policy_attachment" "custom_attachment" {
  for_each   = var.custom_policy_arns
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "managed_attachment" {
  for_each   = var.managed_policy_arns
  role       = aws_iam_role.role.name
  policy_arn = each.value
}
