// File: modules/iam/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the Generic IAM Module
// Exposes the ARN and name of the created IAM role.
// ---------------------------------------------------------------------------
output "role_arn" {
  description = "The ARN of the created IAM role."
  value       = aws_iam_role.role.arn
}

output "role_name" {
  description = "The name of the created IAM role."
  value       = aws_iam_role.role.name
}

output "inline_policy" {
  description = "The inline policy attached to the IAM role, if any."
  value       = length(data.local_file.inline_policy) > 0 ? data.local_file.inline_policy[0].content : ""
  sensitive   = true
}

output "role_type" {
  description = "The type of the IAM role (e.g., eks_cluster, eks_node)."
  value       = var.role_type
}

