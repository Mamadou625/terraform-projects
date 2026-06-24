# ---------------------------------------------------------------------------
# One-time bootstrap: remote state backend + GitHub Actions OIDC CI role.
# Run this ONCE with local state before initialising the environments.
# ---------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# --- Remote state bucket (S3 native locking via use_lockfile; no DynamoDB) ---
resource "aws_s3_bucket" "tfstate" {
  bucket = var.state_bucket_name

  # Protect the state bucket from accidental terraform destroy
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = var.state_bucket_name
    Purpose = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- GitHub Actions OIDC provider ---
# Thumbprint is no longer validated by AWS for this provider, but the argument
# is still required; this is GitHub's well-known intermediate CA thumbprint.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# --- CI role assumable from this repo via OIDC ---
data "aws_iam_policy_document" "ci_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Allow PR plans, dev apply on main, and prod apply via the prod environment.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_owner}/${var.github_repo}:pull_request",
        "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main",
        "repo:${var.github_owner}/${var.github_repo}:environment:prod",
      ]
    }
  }
}

resource "aws_iam_role" "ci" {
  name               = "${var.project_name}-github-ci"
  assume_role_policy = data.aws_iam_policy_document.ci_assume.json

  tags = {
    Name = "${var.project_name}-github-ci"
  }
}

# Broad permissions so CI can manage the full three-tier stack. For a tighter
# posture, replace AdministratorAccess with a scoped policy covering only
# EC2/VPC/ELB/ASG/RDS/IAM/S3/SecretsManager plus the state bucket.
resource "aws_iam_role_policy_attachment" "ci_admin" {
  role       = aws_iam_role.ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
