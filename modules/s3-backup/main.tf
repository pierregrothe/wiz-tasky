// File: modules/s3-backup/main.tf
// ---------------------------------------------------------------------------
// S3 Backup Module for wiz-tasky Project
// This module provisions an S3 bucket for storing database backups.
// The bucket's versioning is enabled using a separate resource (aws_s3_bucket_versioning)
// as recommended, and the bucket policy is configured based on the remediation_mode variable:
//   - When remediation_mode is false (misconfigured), the bucket policy allows public read access.
//   - When remediation_mode is true (remediated), the bucket policy denies public access.
// ---------------------------------------------------------------------------

resource "aws_s3_bucket" "backup" {
  bucket = var.bucket_name

  tags = merge(
    local.merged_tags,
    {
      Name      = var.bucket_name,
      component = "s3-backup"
    }
  )
}

# Enable versioning using the recommended resource instead of inline versioning.
resource "aws_s3_bucket_versioning" "backup_versioning" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Define the bucket policy document based on remediation_mode.
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "PublicReadForMisconfigured"
    effect = var.remediation_mode ? "Deny" : "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.backup.arn}/*"]
  }
}

# Apply the bucket policy.
resource "aws_s3_bucket_policy" "backup_policy" {
  bucket = aws_s3_bucket.backup.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
