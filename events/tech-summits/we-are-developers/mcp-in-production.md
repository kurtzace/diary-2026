# MCP in Production

Pre-reading for two WeAreDevelopers Conference India 2026 sessions on taking the Model
Context Protocol (MCP) past the demo stage.

## Overview

MCP is the open standard (originated by Anthropic, now broadly adopted by Claude, ChatGPT,
VS Code, Cursor, etc.) for connecting AI applications to external tools, data sources and
prompts — "a USB-C port for AI apps." Building a server that exposes a couple of tools over
`stdio` is an afternoon's work. The gap between that and a server used by real, multi-tenant
customers is where most of the hard problems live: authentication/authorization (MCP servers
sit in OAuth flows as both client and resource server), audience validation so tokens can't be
replayed against the wrong service ("token passthrough" is explicitly forbidden by the spec),
per-user state isolation, SSRF through server-supplied metadata URLs, and — the theme both
talks below hit — what happens when an agent can call a tool that *does* something (restart a
service, delete a record, export a log) rather than just read something.

## The sessions

- **[1457] What I Got Wrong Shipping an MCP Server for Live Infrastructure** — Pritesh Kiri
  (DevRel Engineer, Harness) · Wed 25 Nov, 12:10-12:40, Stage 1. He owns Harness's Resilience
  Testing MCP — a server whose whole job is letting an agent inject failure into live systems.
  The abstract's framing ("good tool descriptions" advice falling apart once the agent can break
  things on purpose) points to a talk about authorization scoping, confirmation/guardrail
  patterns for destructive tools, and blast-radius containment, not prompt wording. I couldn't
  find the talk's full slide content pre-event; treat the above as inferred from the abstract.
- **[1446] Shipping MCP to Real Users: Scaling, Auth, and the PII Leak You Didn't See Coming**
  — Hadar Geva · Thu 26 Nov, 10:00-10:30, Stage 1. Framed around the demo-to-multi-tenant jump:
  likely covers per-tenant auth/token audience separation, rate limiting, and a concrete story of
  PII surfacing through tool output (logs, search results, or error messages) that wasn't caught
  until production scale. No further detail found; speaker/company bio not independently verified.

## Vocabulary to know going in

- **Token passthrough / audience validation** — an MCP server must verify a token was issued
  *for it*, not just accept and forward whatever the client sent.
- **Confused deputy problem** — an MCP proxy with a static client ID can be tricked into
  forwarding a stolen authorization code if per-client consent isn't enforced.
- **State handle hijacking** — MCP is stateless; servers that mint handles (session/cart/workflow
  IDs) must bind them server-side to the authenticated user, not trust possession of the handle.
- **SSRF via OAuth metadata** — a malicious/compromised MCP server can hand a client URLs
  pointing at internal IPs or cloud metadata endpoints (`169.254.169.254`) during discovery.
- **Scope minimization** — avoid omnibus scopes (`*`, `admin`); use progressive/step-up scope
  elevation instead.
(Source: modelcontextprotocol.io introduction + security best-practices docs, 2026-07-28 spec.)

## Connects to your work

You've shipped two FastMCP servers at Cisco — a Bedrock-Knowledge-Bases-backed onboarding
assistant (pulling from GitHub/Confluence/Webex/S3) and an Express/GraphQL/React prompt-management
tool on Bedrock Prompt Management — plus hands-on PII cleaning for DNS/proxy/firewall log exports
under GDPR. That's almost exactly the intersection these two talks cover.

Two things worth asking the speakers directly:
1. For the onboarding assistant: did they hit PII leakage through *retrieved context* (a doc or
   chat transcript surfacing a name/email in a tool response) rather than through the tool's
   primary output — and how did they scope/redact at the retrieval layer vs. the output layer?
2. For the Resilience Testing MCP: what's their confirmation/approval pattern for destructive
   tool calls — a human-in-the-loop step, scoped credentials per tool, or dry-run mode — and how
   does that compare to how you'd gate a tool that could mutate your reporting pipeline's data?
