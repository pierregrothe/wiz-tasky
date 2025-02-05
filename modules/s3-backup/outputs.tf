// File: modules/s3-backup/outputs.tf
// ---------------------------------------------------------------------------
// Outputs for the S3 Backup Module
// Exposes the bucket name and ARN for reference.
// ---------------------------------------------------------------------------

output "bucket_name" {
  description = "The name of the S3 backup bucket."
  value       = aws_s3_bucket.backup.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 backup bucket."
  value       = aws_s3_bucket.backup.arn
}
