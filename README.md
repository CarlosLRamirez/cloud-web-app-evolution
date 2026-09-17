# Web App Evolution Lab

A learning lab showing how a web application can evolve, step by step, from a simple monolith into a modern, decoupled, automated architecture — all deployed on AWS with Terraform.

The application is **BrewOps**, a fictional craft taproom's ordering system — but it's just the pretext. The focus of this repository is the **infrastructure and DevOps practices** behind each stage: what changes in the architecture, why, and what's gained (or complicated) by doing it.

## What you'll find here

An incremental walkthrough of different versions of the same application, each a bit more mature than the last in how it's deployed:

1. **Monolith on a single instance** — front, backend, and database live together on the same server.
2. **Layer separation** — web, application, and data start living apart.
3. **Decoupling** — layers stop talking directly and go through a load balancer and/or queues.
4. **Microservices** — the backend splits into independent services.
5. **Static frontend on S3** — the web layer separates completely from the backend.
6. **Containers / serverless** — microservices migrate to containers or Lambda functions.
7. **Automation** — infrastructure and deployments, manual until now, get automated with pipelines.

The details of each stage — what it demonstrates and its current status — live in the [**Roadmap**](docs/ROADMAP.md).

## How this is organized

- [`docs/ROADMAP.md`](docs/ROADMAP.md) — the full plan, phase by phase.
- `terraform/` — all infrastructure, defined as code.
- `app/` — the example application's code.

## Principles of this lab

- **All infrastructure is code.** Nothing is created by hand in the AWS console on a permanent basis; everything is represented in Terraform.
- **Complexity is earned, not assumed.** Each phase exists because it solves a real limitation of the previous one (scalability, coupling, security, deployment speed), not because it's "what's done."
- **The app's code stays simple on purpose.** What evolves is the infrastructure around it, not the application itself.

## Status & Progress

**Phase 1 — Monolith on a single EC2 instance** *(in progress)*

- [x] Remote Terraform state backend (S3, with native locking, compliant with the org's mandatory resource-tagging policy)
- [x] Read-only cross-account access to the landing zone's networking outputs, via a dedicated least-privilege IAM role
- [x] Security Group for the application host (SSH restricted to the operator, app port public, defined and validated end-to-end)
- [ ] EC2 instance provisioning
- [ ] Migrate this phase's Terraform state to the remote backend
- [ ] Manual deployment of the BrewOps app (Node.js + Express + PostgreSQL) over SSH
- [ ] End-to-end verification: public access + data persistence

Later phases don't have a progress checklist yet — they'll get one once work on them starts.
