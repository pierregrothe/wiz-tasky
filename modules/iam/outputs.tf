// File: modules/iam/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the IAM Module
// Exposes the ARN of the created IAM role so other modules can reference it.
// ---------------------------------------------------------------------------

output "role_arn" {
  description = "The ARN of the created IAM role."
  value       = aws_iam_role.role.arn
}

output "role_name" {
  description = "The name of the created IAM role."
  value       = aws_iam_role.role.name
}