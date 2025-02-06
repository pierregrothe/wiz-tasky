// File: variables.tf
// ---------------------------------------------------------------------------
// Global Variables for the wiz-tasky Project
// ---------------------------------------------------------------------------

// -------------------------
// Project and Environment
// -------------------------
variable "project_name" {
  type        = string
  description = "Project name (e.g., wiz-tasky)"
  default     = "wiz-tasky"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-2"
}

variable "assessment_mode" {
  type        = bool
  description = "Toggle for assessment mode (introduces intentional misconfigurations)"
  default     = false
}

// -------------------------
// Tagging Variables
// -------------------------
variable "tags_default" {
  type        = map(string)
  description = "Default tags for all resources (e.g., { owner = 'pgrothe', team = 'DevOps', cost-center = 'CC-1234', managed-by = 'Terraform' })"
  default     = {
    owner      = "pgrothe"
    team       = "DevOps"
    cost-center = "CC-1234"
    managed-by = "Terraform"
  }
}

variable "tags_env" {
  type        = map(string)
  description = "Environment-specific tags (e.g., { managed-by = 'Terraform' })"
  default     = {
    managed-by = "Terraform"
  }
}

// -------------------------
// VPC Configuration
// -------------------------
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones for subnet placement"
  default     = ["us-east-2a", "us-east-2b"]
}

// -------------------------
// Bastion Host Configuration
// -------------------------
variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for the Bastion host."
  default     = "t3.micro"
}

variable "bastion_ami_id" {
  type        = string
  description = "AMI ID for the Bastion host (e.g., Amazon Linux 2023 AMI)."
  default     = "ami-018875e7376831abe"
}

variable "bastion_allowed_ssh_ip" {
  type        = string
  description = "Allowed CIDR for SSH access to the Bastion host (e.g., 70.53.172.107/32)."
  default     = "70.53.172.107/32"
}

// -------------------------
// Global Remediation Mode
// -------------------------
variable "remediation_mode" {
  type        = bool
  description = "Set to true to deploy a remediated (secure) configuration; false to deploy intentionally misconfigured resources for assessment."
  default     = false
}

// -------------------------
// MongoDB Configuration
// -------------------------
variable "mongodb_ami_id" {
  type        = string
  description = "AMI ID to use for the MongoDB EC2 instance"
  default     = "ami-07c65f0fc562b275d"
}

variable "mongodb_admin_username" {
  type        = string
  description = "MongoDB admin username"
}

variable "mongodb_admin_password" {
  type        = string
  description = "MongoDB admin password"
  sensitive   = true
}

variable "mongodb_instance_type" {
  type        = string
  description = "EC2 instance type for the MongoDB host."
  default     = "t3.micro"
}

// -------------------------
// EKS Configuration
// -------------------------
variable "eks_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster."
  default     = "1.32" // Adjust as needed.
}

variable "eks_node_role_arn" {
  type        = string
  description = "ARN of the IAM role for the EKS node group."
}

variable "eks_desired_size" {
  type        = number
  description = "Desired number of worker nodes in the EKS node group."
  default     = 1
}

variable "eks_min_size" {
  type        = number
  description = "Minimum number of worker nodes in the EKS node group."
  default     = 1
}

variable "eks_max_size" {
  type        = number
  description = "Maximum number of worker nodes in the EKS node group."
  default     = 1
}

variable "eks_instance_types" {
  type        = list(string)
  description = "List of EC2 instance types for the EKS node group."
  default     = ["t3.medium"]
}
