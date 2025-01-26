variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "CIDR block for Public Subnet in AZ-a"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "CIDR block for Public Subnet in AZ-b"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
  type        = string
  description = "CIDR block for Private Subnet in AZ-a"
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_b" {
  type        = string
  description = "CIDR block for Private Subnet in AZ-b"
  default     = "10.0.12.0/24"
}