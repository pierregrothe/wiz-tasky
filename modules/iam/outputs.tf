// File: modules/iam/generic/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the Generic IAM Module
// Exposes the ARN and name of the created IAM role for reference in other modules.
// ---------------------------------------------------------------------------

output "role_arn" {
  description = "The ARN of the created IAM role."
  value       = aws_iam_role.role.arn
}

output "role_name" {
  description = "The name of the created IAM role."
  value       = aws_iam_role.role.name
}
