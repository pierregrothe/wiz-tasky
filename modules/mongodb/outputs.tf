// File: modules/mongodb/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the MongoDB Module
// Exposes the EC2 instance ID and the MongoDB connection string file location.
// ---------------------------------------------------------------------------

output "mongodb_instance_id" {
  description = "The ID of the deployed MongoDB EC2 instance."
  value       = aws_instance.mongodb_instance.id
}

output "mongodb_connection_string_file" {
  description = "The file on the instance that contains the MongoDB connection string."
  value       = "/home/ec2-user/mongodb_connection_string.txt"
}
