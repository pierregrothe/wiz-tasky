// File: modules/bastion/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the Bastion Host Module
// Defines all necessary parameters to deploy the Bastion host, including
// instance specifications, networking details, and tagging information.
// ---------------------------------------------------------------------------

/*
  Variable: vpc_id
  Description: The ID of the VPC where the Bastion host will be deployed.
*/
variable "vpc_id" {
  type        = string
  description = "VPC ID for the Bastion host."
}

/*
  Variable: public_subnet_id
  Description: The ID of the public subnet in which the Bastion host will be deployed.
*/
variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for the Bastion host."
}

/*
  Variable: bastion_instance_type
  Description: The EC2 instance type for the Bastion host.
  Default: "t3.micro"
*/
variable "bastion_instance_type" {
  type        = string
  description = "EC2 instance type for the Bastion host."
  default     = "t3.micro"
}

/*
  Variable: ami_id
  Description: The AMI ID for the Bastion host. (Amazon Linux 2023 AMI in us-east-2, for example)
  Default: "ami-018875e7376831abe"
*/
variable "ami_id" {
  type        = string
  description = "AMI ID for the Bastion host."
  default     = "ami-018875e7376831abe"
}

/*
  Variable: allowed_ssh_ips
  Description: A list of CIDR blocks allowed to SSH into the Bastion host.
  Example: ["203.0.113.0/24"] (Replace with your home/work IP range)
*/
variable "allowed_ssh_ips" {
  type        = list(string)
  description = "List of allowed CIDR blocks for SSH access to the Bastion host."
}

/*
  Variable: project_name
  Description: The project name for resource naming and tagging.
*/
variable "project_name" {
  type        = string
  description = "Project name for resource naming."
}

/*
  Variable: environment_name
  Description: The deployment environment (e.g., dev, staging, prod) for resource naming.
*/
variable "environment_name" {
  type        = string
  description = "Deployment environment (dev, staging, prod)."
}

/*
  Variable: tags
  Description: Base tags to apply to resources in this module.
*/
variable "tags" {
  type        = map(string)
  description = "Base tags to apply to all resources in this module."
}
