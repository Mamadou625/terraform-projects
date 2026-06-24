# Project-03 — AWS Three-Tier Web Architecture (Terraform)

A highly available three-tier web application on AWS, built end-to-end with Terraform and
deployed through a GitHub Actions CI/CD pipeline.

![AWS three-tier web architecture](assets/architecture.png)

```
Internet
   │
   ▼
[ Internet-facing ALB ]  ── public subnets (AZ-a / AZ-b)
   │
   ▼
[ Web tier ASG ]  Nginx + React build   (public subnets)
   │  /api  ─────────────►
   ▼
[ Internal ALB ]  ── private app subnets
   │
   ▼
[ App tier ASG ]  Node.js :4000          (private app subnets)
   │
   ▼
[ Aurora MySQL ]  writer + reader (multi-AZ)  (private, isolated DB subnets)
```

- **Web tier** — Nginx serves the React build and proxies `/api/` to the internal ALB.
- **App tier** — Node.js on port 4000, reads/writes Aurora MySQL.
- **Database tier** — Aurora MySQL cluster (writer + reader) across two AZs; master
  password is generated and stored in **AWS Secrets Manager** (never in code/tfvars).
- Load balancing, ELB health checks, Auto Scaling Groups and target-tracking scaling
  policies at the web and app tiers.
- A **single NAT Gateway** provides outbound internet for the private tiers.

## Layout

```
Project-03/
├── modules/
│   ├── vpc/              # VPC, 6 subnets (web/app/db × 2 AZ), IGW, NAT, route tables, DB subnet group
│   ├── security_groups/  # ext_alb → web → int_alb → app → db (chained by SG references)
│   ├── iam/              # EC2 role + instance profile (SSM, S3 read, Secrets Manager read)
│   ├── database/         # Aurora MySQL cluster (writer + reader)
│   ├── app_tier/         # internal ALB + TG(:4000) + LT + ASG + scaling
│   ├── web_tier/         # internet ALB + TG(:80) + LT + ASG + scaling
│   └── s3/               # application-code bucket
├── environments/
│   ├── dev/              # wires modules; S3 backend key project-03/dev/terraform.tfstate
│   └── prod/             # same, prod-scaled tfvars; key project-03/prod/terraform.tfstate
├── application-code/     # nginx + user-data templates (templatefile inputs)
├── bootstrap/            # one-time: state bucket + GitHub OIDC provider + CI role
└── .gitignore

# CI/CD workflows live at the REPO ROOT (GitHub only runs .github/workflows there):
../.github/workflows/project-03-terraform-plan.yml
../.github/workflows/project-03-terraform-apply.yml
```

## Prerequisites

- Terraform **>= 1.10** (uses S3 backend **native locking** via `use_lockfile`; no DynamoDB).
- AWS account + credentials with admin (for the one-time bootstrap).
- A globally unique name for the state bucket and the app-code buckets — edit the defaults
  in `bootstrap/terraform.tfvars`, `environments/*/providers.tf` (backend `bucket`) and
  `environments/*/terraform.tfvars` (`app_bucket_name`) to match.

## Deploy

### 1. Bootstrap (run once, local state)

```bash
cd bootstrap
# edit terraform.tfvars: state_bucket_name, github_owner, github_repo
terraform init
terraform apply
terraform output ci_role_arn   # note this for GitHub
```

This creates the remote state S3 bucket, the GitHub Actions OIDC provider and the CI IAM
role.

### 2. Build the React frontend, then apply

The application code is uploaded to S3 **by Terraform** (`aws_s3_object` in the `s3`
module), and the ASGs depend on those objects, so instances find the code on first boot —
no manual upload or instance recycling. The app-tier source is committed; the **web build
must exist on disk before apply** (CI runs this automatically):

```bash
cd application-code/web-tier
npm install && npm run build   # produces web-tier/build/ that Terraform uploads

cd ../../environments/dev
terraform init                 # configures the S3 backend
terraform apply
terraform output web_alb_dns
```

Repeat for `environments/prod` (or let CI handle it — see below).

### 3. Database schema

No manual seeding needed: the **app-tier user-data** runs an idempotent
`CREATE DATABASE/TABLE IF NOT EXISTS` against Aurora on boot (it reads the managed
credentials from Secrets Manager). The `transactions` table the Node app expects is created
automatically.

## CI/CD (GitHub Actions)

Both workflows build the React frontend (`npm run build`) before running Terraform, so the
S3 uploads include the latest bundle.

- **`project-03-terraform-plan.yml`** — on PRs touching `Project-03/**`: `fmt`/`init`/
  `validate`/`plan` for **prod**, and posts the plan as a PR comment. Review gate.
- **`project-03-terraform-apply.yml`** — on merge to `main`: builds the frontend and applies
  **prod** automatically (auto-approve, no manual gate). To require manual approval, add
  `environment: prod` to the `apply-prod` job and configure a `prod` GitHub Environment with
  required reviewers.

One-time GitHub repo setup:

1. Add a repository **variable** `AWS_CI_ROLE_ARN` = the `ci_role_arn` from bootstrap.
2. Authentication uses **OIDC** — no AWS access keys are stored in GitHub.

## Cost & cleanup

Aurora, the NAT Gateway and both ALBs are **not** free-tier and bill hourly. Tear down an
environment when you are done (leave `bootstrap` in place so state survives):

```bash
cd environments/dev && terraform destroy
```

## Notes

- 2 AZs are used to match the architecture diagram; Aurora multi-AZ needs ≥ 2.
- No SSH keys: instances are reached via **SSM Session Manager**.
- Secrets, state and `*.auto.tfvars` are git-ignored; nothing sensitive is committed.
