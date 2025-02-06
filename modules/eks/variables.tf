/*
  File: modules/eks/variables.tf
  Purpose:
    - Define input variables for the EKS module.
*/

variable "project_name" {
  type        = string
  description = "Project name used for naming resources."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod) used for naming resources."
}

variable "tags" {
  type        = map(string)
  description = "Base tags applied to resources (merged from Terraform Cloud variables)."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to use for the EKS cluster (typically public subnets from your VPC module)."
}

variable "cluster_role_arn" {
  type        = string
  description = "ARN of the IAM role to be used by the EKS cluster."
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster."
  default     = "1.21"  // Adjust as needed.
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the IAM role to be used by the EKS node group."
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes."
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes."
  default     = 1
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for the EKS node group."
  default     = ["t3.medium"]
}
