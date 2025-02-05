// File: modules/s3-backup/main.tf
// ---------------------------------------------------------------------------
// S3 Backup Module for wiz-tasky Project
// This module provisions an S3 bucket for storing database backups.
// It enables bucket versioning using a separate resource and applies a bucket policy
// that is conditionally set based on the remediation_mode variable.
// To allow the misconfigured (public) bucket policy to be applied, we disable the 
// BlockPublicPolicy setting using an aws_s3_bucket_public_access_block resource.
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

# Disable S3 block public access so that our public bucket policy can be applied.
resource "aws_s3_bucket_public_access_block" "backup_public_access" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = false
  block_public_policy     = false  # This is key – disables blocking public bucket policies.
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable versioning using a separate resource (recommended approach).
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
