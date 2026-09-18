# Roadmap

This project walks the same small web application through a series of deployment architectures, each one solving a real limitation of the previous stage. The application code stays intentionally simple throughout — what evolves is the infrastructure around it, built entirely with **Terraform** on **AWS**.

## The scenario: BrewOps

To keep every phase grounded in something concrete (rather than an abstract "Todo app"), the application is **BrewOps**, a fictional craft taproom's ordering system. It starts as a simple menu-and-orders app and grows a domain rich enough to justify each architectural step:

- **Catalog** — the tap list (beers currently on tap, prices, availability).
- **Orders** — customers place pour orders; the taproom staff work through them.
- **Inventory** — keg levels and ingredient stock.
- **Loyalty** — a "Mug Club" membership/rewards program.
- **Notifications** — letting a customer know their order is ready.
- **Multi-location** — BrewOps eventually operates more than one taproom.

These aren't built all at once — they're introduced as each phase needs a reason to exist (see below).

## Baseline — Landing zone *(separate repository)*

This project is the first workload deployed on top of a multi-account AWS Organization landing zone, built and maintained separately — see [aws-multi-account-landing-zone](https://github.com/CarlosLRamirez/aws-multi-account-landing-zone). It keeps evolving on its own as new needs come up. The base networking (VPC, subnets, route tables, etc.) it provisions is consumed here via Terraform remote state — it isn't recreated in this project.

## Phase 1 — Monolith on a single EC2 instance ⬅ *current phase*

BrewOps starts as a single Node.js + Express + PostgreSQL app: a tap list customers can browse and a simple order form, all on one EC2 instance. Infrastructure is fully defined in Terraform, including its own remote state backend; the application deployment itself is manual (over SSH), with no pipeline yet.

**Demonstrates:** Terraform fundamentals (providers, remote state, data sources), Security Group design, AWS compute provisioning, and running a relational database alongside an application on the same host.

## Phase 2 — Separate the layers (web / app / data)

The orders/tap-list database moves to its own instance (or to RDS), and optionally the web layer separates from the application layer. The layers no longer share a host, though they still communicate directly.

**Demonstrates:** reusable Terraform modules, managing multiple related resources, tighter per-layer network security, and the first real "what lives where" decisions.

## Phase 3 — Decouple the layers with a load balancer and/or queues

An Application Load Balancer sits in front of the web/app layer. An **order queue** (SQS) decouples the moment a customer places an order from the moment staff fulfill it — the same way a real taproom's pour queue works — so a burst of orders (a busy Friday night) no longer risks overwhelming the app directly.

**Demonstrates:** load balancing, health checks, asynchronous decoupling patterns, and Auto Scaling Groups where applicable.

## Phase 4 — Break the backend into microservices

The monolithic backend splits along BrewOps' natural domain boundaries: a **catalog service** (tap list), an **orders service**, an **inventory service** (keg/ingredient stock), and a **loyalty service** (Mug Club rewards) — each with its own deployment lifecycle.

**Demonstrates:** service boundary design, inter-service communication, and managing multiple deployment artifacts.

## Phase 5 — Static frontend on S3 (+ optional CloudFront)

The customer-facing tap list and ordering UI separates completely from the backend and is served from S3 as a static site, optionally behind CloudFront, talking to the microservices via an API.

**Demonstrates:** static hosting, content distribution, and a true infrastructure-level front/back split.

## Phase 6 — Containers or serverless for the microservices

The microservices from Phase 4 migrate to containers (ECS/EKS) or Lambda functions depending on the use case — for example, the notifications service (order-ready alerts) is a natural fit for an event-driven Lambda.

**Demonstrates:** container orchestration or serverless compute, artifact packaging, and finer-grained IAM.

## Phase 7+ — Automation and integrations, and beyond

From here on (running alongside the phases above rather than strictly after them), GitHub Actions pipelines automate what was done by hand until now: `terraform plan/apply`, application deployment, tests, and more. This phase is intentionally open-ended and will grow with the project — real-world integrations (payment provider, email/SMS notifications), multi-location support for BrewOps, observability, secrets management, tighter IAM policies, disaster recovery, and whatever else comes up along the way.
