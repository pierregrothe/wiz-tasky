// File: modules/eks/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the EKS Module for wiz-tasky Project
// ---------------------------------------------------------------------------

variable "project_name" {
  type        = string
  description = "Project name for resource naming (e.g., wiz-tasky)"
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)"
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to EKS resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the EKS cluster will be deployed (typically public subnets)"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster"
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.32"  // Adjust as needed.
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS node group"
}

variable "desired_size" {
  type        = number
  description = "Desired number of nodes in the EKS node group"
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Minimum number of nodes in the EKS node group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of nodes in the EKS node group"
  default     = 1
}

variable "instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the EKS node group"
  default     = ["t3.medium"]
}
