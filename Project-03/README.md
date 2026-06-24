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

### 2. Upload application code to S3

The instances pull their code from the app-code bucket on boot. Build the React app and
upload both tiers (source for the workshop app lives in
`../Project-02/aws-three-tier-web-architecture-workshop/application-code`):

```bash
# web tier (build first)
cd <web-tier-source>
npm install && npm run build
aws s3 cp ./build  s3://<app_bucket_name>/web-tier/build --recursive

# app tier (source + package.json)
aws s3 cp <app-tier-source> s3://<app_bucket_name>/app-tier --recursive
```

> The bucket is created by the `s3` module during `terraform apply`, so on the very first
> apply the instances may come up before code is uploaded — upload, then let the ASG
> recycle instances (or terminate them) to re-run user-data.

### 3. Apply an environment

```bash
cd environments/dev
terraform init      # configures the S3 backend
terraform apply
terraform output web_alb_dns
```

Repeat for `environments/prod` (or let CI handle it).

### 4. Seed the database (one-time, post-apply)

Like the AWS workshop, connect to an **app tier** instance via SSM Session Manager and
create the schema/table the Node app expects (credentials are in Secrets Manager and were
written to `DbConfig.js` by user-data):

```sql
CREATE DATABASE IF NOT EXISTS webappdb;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions (
  id INT NOT NULL AUTO_INCREMENT,
  amount DECIMAL(10,2),
  description VARCHAR(100),
  PRIMARY KEY (id)
);
```

## CI/CD (GitHub Actions)

- **`project-03-terraform-plan.yml`** — on PRs touching `Project-03/**`: `fmt`/`init`/
  `validate`/`plan` for dev **and** prod, and posts the plan as a PR comment. Review gate.
- **`project-03-terraform-apply.yml`** — on merge to `main`: applies **dev** automatically,
  then **prod** automatically (auto-approve, no manual gate). To require manual approval for
  prod, add `environment: prod` to the `apply-prod` job and configure a `prod` GitHub
  Environment with required reviewers.

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
