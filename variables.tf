variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones to use"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "ingress_rules" {
  type        = list(any)
  description = "List of ingress security group rules"
  default     = []
}

variable "egress_rules" {
  type        = list(any)
  description = "List of egress security group rules"
  default     = []
}