# Web App Evolution Lab

A learning lab showing how a web application can evolve, step by step, from a simple monolith into a modern, decoupled, automated architecture — all deployed on AWS with Terraform.

The application itself (a simple web app) is just the pretext. The focus of this repository is the **infrastructure and DevOps practices** behind each stage: what changes in the architecture, why, and what's gained (or complicated) by doing it.

## What you'll find here

An incremental walkthrough of different versions of the same application, each a bit more mature than the last in how it's deployed:

1. **Monolith on a single instance** — front, backend, and database live together on the same server.
2. **Layer separation** — web, application, and data start living apart.
3. **Decoupling** — layers stop talking directly and go through a load balancer and/or queues.
4. **Microservices** — the backend splits into independent services.
5. **Static frontend on S3** — the web layer separates completely from the backend.
6. **Containers / serverless** — microservices migrate to containers or Lambda functions.
7. **Automation** — infrastructure and deployments, manual until now, get automated with pipelines.

The details of each stage — what it practices and its current status — live in the [**Roadmap**](ROADMAP.md).

## How this is organized

- [`ROADMAP.md`](ROADMAP.md) — the full plan, phase by phase.
- [`docs/runbooks/`](docs/runbooks) — step-by-step guides for building each phase.
- `terraform/` — all infrastructure, defined as code.
- `app/` — the example application's code.

## Principles of this lab

- **All infrastructure is code.** Nothing is created by hand in the AWS console on a permanent basis; everything is represented in Terraform.
- **Complexity is earned, not assumed.** Each phase exists because it solves a real limitation of the previous one (scalability, coupling, security, deployment speed), not because it's "what's done."
- **The app's code stays simple on purpose.** What evolves is the infrastructure around it, not the application itself.
