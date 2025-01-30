variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
