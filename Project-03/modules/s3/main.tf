# S3 bucket holding the application code (web-tier build + app-tier source)
resource "aws_s3_bucket" "app_code" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_ownership_controls" "app_code" {
  bucket = aws_s3_bucket.app_code.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "app_code" {
  bucket = aws_s3_bucket.app_code.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "app_code" {
  bucket = aws_s3_bucket.app_code.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_code" {
  bucket = aws_s3_bucket.app_code.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# --- Application code objects ---
# Uploaded as part of apply so instances find the code in S3 on first boot.
# The web build must exist on disk before apply (CI runs `npm run build`); if the
# build directory is absent the fileset is empty and no web objects are uploaded.

locals {
  app_tier_files = toset([
    for f in fileset("${var.app_code_dir}/app-tier", "**") : f
    if !startswith(f, "node_modules/")
  ])
  web_build_files = fileset("${var.app_code_dir}/web-tier/build", "**")
}

resource "aws_s3_object" "app_tier" {
  for_each = local.app_tier_files

  bucket = aws_s3_bucket.app_code.id
  key    = "app-tier/${each.value}"
  source = "${var.app_code_dir}/app-tier/${each.value}"
  etag   = filemd5("${var.app_code_dir}/app-tier/${each.value}")
}

resource "aws_s3_object" "web_build" {
  for_each = local.web_build_files

  bucket = aws_s3_bucket.app_code.id
  key    = "web-tier/build/${each.value}"
  source = "${var.app_code_dir}/web-tier/build/${each.value}"
  etag   = filemd5("${var.app_code_dir}/web-tier/build/${each.value}")
}
