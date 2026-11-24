# Observability & SRE: OTEL at Scale

Pre-reading for [1456] **"We Deleted Our Observability Stack and Rebuilt It with OTEL: 12 Engineers to 4 at 20K+ clusters"** — Yash Sharma, Kapil Gautam, Sreeram Venkitesh (DigitalOcean), Wed 25 Nov, 16:50–17:20, Stage 2.

## Overview

The agenda teaser: in 2021, DigitalOcean's internal observability hit a breaking point at 5,000 clusters — audit logs were being lost and metrics scraping failed under volume. By the time of this talk, DO claims the same (now 20,000+ cluster) estate is observed by a 4-person team instead of 12, after rebuilding on OpenTelemetry (OTEL). I could not find a public DigitalOcean engineering blog post, recorded talk, or write-up that confirms these specific numbers or describes the migration architecture — I searched for it and came up empty, so treat the headline figures as the speakers' own claim until you hear the talk. What follows below the fold is general, verifiable OTEL background, not DO-specific detail.

OTEL (OpenTelemetry) is the CNCF standard for instrumenting traces, metrics, and logs behind one vendor-neutral API/SDK and a common wire protocol (OTLP), collected by the **OTEL Collector** (receivers → processors → exporters) and shipped to any backend (Prometheus, a vendor SaaS, OpenSearch, etc.). The pitch for consolidating on it at scale is usually: one instrumentation standard instead of N agents/SDKs per language and per signal type, centralized sampling/filtering in the Collector instead of per-service config sprawl, and the ability to swap backends without re-instrumenting everything — which is plausibly how a team shrinks headcount while scale grows: less bespoke per-service glue to maintain.

## Key concepts to know going in

- **OTLP** — OpenTelemetry's wire protocol for traces/metrics/logs, transport-agnostic (gRPC/HTTP).
- **Collector pipelines** — receiver → processor (batch, filter, sample) → exporter; usually where cost/cardinality control happens.
- **Three signals, one pipeline** — traces, metrics, logs correlated via shared resource attributes (trace_id/span_id in logs).
- **Cardinality explosion** — the usual cause of "metrics scraping fails at scale"; worth listening for how DO controls label/tag cardinality.
- **Audit log loss** — a durability/backpressure problem, not just a monitoring one; listen for how they separated audit-critical data from best-effort telemetry.

## Connects to your work

Your Cisco Observability & Reliability Engineering stack (Prometheus, OpenSearch, Splunk, PagerDuty, Resilience4j, Locust, AWS Lambda) is the same "N tools stitched per signal" shape OTEL consolidation targets — Prometheus for metrics, OpenSearch/Splunk for logs, no unifying trace-correlation layer mentioned in your resume. Two things worth testing against your own setup during Q&A: (1) whether an OTEL Collector in front of your existing Prometheus/OpenSearch backends would let you keep those sinks while cutting per-service instrumentation work, and (2) how they protected "critical audit logs" from drop-on-overload — directly relevant to your DNS/proxy/firewall log export and retention work, where losing audit data has compliance (GDPR) implications, not just operational ones.
