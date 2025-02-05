// File: modules/s3-backup/main.tf
// ---------------------------------------------------------------------------
// S3 Backup Module for wiz-tasky Project
// This module creates an S3 bucket intended for database backups.
// The bucket policy is configured based on the remediation_mode variable:
//   - When remediation_mode is false (misconfigured), the bucket policy allows public read access.
//   - When remediation_mode is true (remediated), the bucket policy denies public access,
//     enforcing least privilege.
// ---------------------------------------------------------------------------

resource "aws_s3_bucket" "backup" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name        = var.bucket_name,
      project     = var.project_name,
      environment = var.environment_name,
      component   = "s3-backup"
    }
  )
}

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

resource "aws_s3_bucket_policy" "backup_policy" {
  bucket = aws_s3_bucket.backup.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
