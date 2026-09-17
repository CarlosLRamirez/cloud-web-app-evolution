# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is a public portfolio project demonstrating AWS/Terraform solution architecture skills, aimed at potential employers and clients (the author is building it out to support Solutions Architect / AWS Cloud Architecture work). It walks a single small web application through progressively more sophisticated deployment architectures — from a single-instance monolith to a decoupled, containerized/serverless system automated with CI/CD — built entirely on AWS with Terraform. The application code itself is intentionally kept simple; what's meant to showcase capability is the infrastructure evolution around it. Because this is portfolio material, public-facing docs (`README.md`, `docs/`) should read as polished and presentable, not as personal scratch notes.

The application is **BrewOps**, a fictional craft taproom's ordering system (tap list catalog, orders, keg/inventory tracking, a "Mug Club" loyalty program, order-ready notifications, eventually multiple taproom locations) — see `docs/ROADMAP.md` for how each domain concept maps to a phase. It's a deliberate choice over a generic "Todo app" so each architectural step (queues, microservices, integrations) has a concrete business reason to exist.

A separate repository (the "landing zone," not part of this one) already provisions the base networking (VPC, subnets) with Terraform, plus org-wide resources (SCPs, a shared Networking account's VPC), inside an AWS Organization. Its state lives in an S3 bucket in the Organization's **Management account**. This repo consumes that networking read-only via `terraform_remote_state` (with cross-account role assumption — see the Phase 1 runbook) rather than recreating it.

**Account/state placement convention:** each AWS account owns its own Terraform state, stored in a bucket within that same account — never in the Management account, which is kept minimal (org governance only) per AWS Landing Zone best practice. The landing zone's state lives in Management because it describes Management/org-level resources; that does not extend to workload accounts. Every workload account here (BrewOps' EC2, and any accounts introduced in later phases) bootstraps and owns its own state bucket. The only legitimate cross-account access is **read-only**, for a workload account to pull specific outputs (VPC id, subnet ids) from the landing zone's state — never the other way around, and never a shared bucket for multiple workload accounts' own state unless a future phase deliberately introduces a centralized CI/CD ("Tooling") account.

## Current state

The repository is in an early planning stage: no application code or Terraform configuration exists in the tracked tree yet. Phase 1 — a Node.js + Express + PostgreSQL monolith on a single EC2 instance, with infrastructure in Terraform but the app deployed manually over SSH — is the active phase being built out. Later phases (layer separation, ALB/queues, microservices, S3 frontend, containers/Lambda, GitHub Actions pipelines) are not started.

## Repository structure and the `private/` convention

- `README.md` and `docs/` (e.g. `docs/ROADMAP.md`) — public-facing material: the pitch and the phase-by-phase roadmap, written for a reader with no execution context (recruiters, clients, other engineers).
- `private/` — the author's own working documentation: step-by-step execution runbooks (`private/runbooks/`) with exact commands, prerequisites, evidence checklists, and a running log of decisions. This directory is listed in `.gitignore` and is intentionally never committed — it does not ship in the public repo. **Never surface runbook contents, file names, or structure in public docs** (`README.md`, `docs/`) — those are the author's private process notes, not portfolio material. When asked to update the roadmap, edit `docs/ROADMAP.md`; when asked about runbooks, edit files under `private/runbooks/`.
- Planned but not yet present: `terraform/` (per-phase infrastructure, including a `terraform/bootstrap` config for the remote state backend) and `app/` (the example application's code).

## Language and content rules

- **Language:** everything public (`README.md`, `docs/`) is written in English. Everything private (`private/`) is written in Spanish. Don't mix languages within a file or translate one side into the other's language.
- **No sensitive information, anywhere:** never publish AWS account IDs, real IP addresses, email addresses, ARNs, resource names/hostnames tied to the real account, or similar identifying details — in public docs *or* private ones. Use placeholders (e.g. `<AWS_ACCOUNT_ID>`, `<REGION>`) instead. This applies to code, Terraform, commit messages, and docs alike.

## Working conventions (from the private roadmap/runbooks)

- All infrastructure is Terraform-only; nothing is created by hand in the AWS console on a permanent basis (the one deliberate exception is bootstrapping an EC2 SSH key pair).
- Each phase's Terraform state is meant to live in a remote S3 backend with native locking (`use_lockfile = true`, Terraform >= 1.10 — no DynamoDB table needed). The bucket for that backend is itself provisioned by a small, separate Terraform config kept on local state (`terraform/bootstrap`), to sidestep the chicken-and-egg problem of needing a backend before it exists.
- **The AWS Organization enforces a tagging SCP**: it explicitly denies `ec2:RunInstances`, `rds:CreateDBInstance`, and `s3:CreateBucket` unless the request includes `Project` and `Environment` tags (`aws:RequestTag` conditions — an explicit SCP deny, so it applies even to an admin role and can't be bypassed with more IAM permissions). Every provider block in this repo sets these via `default_tags` so any resource created through it automatically satisfies the SCP — don't remove `default_tags` or create EC2/RDS/S3 resources through a provider that lacks it. If a `terraform apply` fails with `AccessDenied ... explicit deny in a service control policy`, this is the first thing to check.
- **The `hashicorp/aws` provider must stay >= 6.22** (see `terraform/bootstrap/versions.tf`). That version is what added S3 tag-on-create support (tags sent inside the `CreateBucket` call itself via `CreateBucketConfiguration`, requiring `s3:TagResource` in addition to `s3:CreateBucket`). Older provider versions create the bucket first and tag it in a separate call, which the tagging SCP's `aws:RequestTag` condition can't see — that combination will always fail with the SCP deny above, no matter what `default_tags` is set to. Don't downgrade below 6.22 for any config that creates S3 buckets.
- Markdown is linted against `.markdownlint.json` (default ruleset with the line-length rule `MD013` disabled).
