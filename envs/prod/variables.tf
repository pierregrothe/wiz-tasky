variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for subnets."
  type        = list(string)
}

variable "tags" {
  description = "Common tags for all resources."
  type        = map(string)
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    ipv6_cidr_blocks = list(string)
    description     = string
  }))
}

variable "egress_rules" {
  description = "List of egress rules for the security group."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    ipv6_cidr_blocks = list(string)
    description     = string
  }))
}
