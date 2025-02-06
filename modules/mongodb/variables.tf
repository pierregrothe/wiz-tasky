// File: modules/mongodb/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the MongoDB Module
// ---------------------------------------------------------------------------

variable "vpc_id" {
  type        = string
  description = "The VPC ID in which to deploy the MongoDB instance."
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of a private subnet in which to deploy the MongoDB instance."
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type for the MongoDB server."
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the MongoDB instance (e.g., Amazon Linux 2 AMI)."
}

variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair to use for SSH access to the MongoDB instance."
}

variable "mongodb_admin_username" {
  type        = string
  description = "The admin username for MongoDB."
}

variable "mongodb_admin_password" {
  type        = string
  description = "The admin password for MongoDB."
  sensitive   = true
}

variable "remediation_mode" {
  type        = bool
  description = "Toggle for remediation mode: true for a remediated (secure) configuration, false for misconfigured (public) configuration."
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to the MongoDB instance and related resources."
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging."
}

variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the VPC, used to restrict access in remediated mode."
}