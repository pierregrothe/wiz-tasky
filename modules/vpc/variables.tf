// File: modules/vpc/variables.tf
// ---------------------------------------------------------------------------
// Input Variables for the VPC Module
// This file defines all the input variables required by the VPC module.
// ---------------------------------------------------------------------------

/*
  Variable: vpc_cidr
  Description: The CIDR block for the VPC.
  Example: "10.0.0.0/16"
*/
variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

/*
  Variable: public_subnets_cidr
  Description: List of CIDR blocks for public subnets.
  Example: ["10.0.1.0/24", "10.0.2.0/24"]
*/
variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets."
}

/*
  Variable: private_subnets_cidr
  Description: List of CIDR blocks for private subnets.
  Example: ["10.0.101.0/24", "10.0.102.0/24"]
*/
variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets."
}

/*
  Variable: availability_zones
  Description: List of Availability Zones where the subnets will be created.
  Example: ["us-east-2a", "us-east-2b"]
*/
variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones for subnet placement."
}

/*
  Variable: project_name
  Description: The project name used for resource naming and tagging.
*/
variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging."
}

/*
  Variable: environment_name
  Description: The deployment environment (dev, staging, prod) used for naming and tagging.
*/
variable "environment_name" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

/*
  Variable: tags
  Description: Base tags to apply to all resources in this module.
  This should be a merged map of default and environment-specific tags.
*/
variable "tags" {
  type        = map(string)
  description = "Base tags to apply to all resources in this module."
}