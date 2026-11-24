# WeAreDevelopers Conference India 2026 — My Plan

Bengaluru, Wed 25 – Thu 26 Nov 2026. Event id 19, agenda source: [about.md](about.md).
Planned against my resume (17y full-stack: Java/Spring, React, Python, AWS/DevOps, and
recent MCP/Agentic AI work at Cisco — FastMCP onboarding agent, Bedrock prompt management,
AI code review, observability).

## Selected sessions (15)

### Wednesday 25 Nov

| Time | ID | Session | Why it fits |
|---|---|---|---|
| 10:00 | 1539 | Official Opening of WeAreDevelopers Conference India | Sets context for both days. |
| 10:10 | 1503 | From the IT Revolution to the Agentic Era (Thomas Dohmke, GitHub) | Mainstage keynote on IDE → agent shift, frames your own move into MCP/agent tooling. |
| 12:10 | 1457 | What I Got Wrong Shipping an MCP Server for Live Infrastructure | You built 2 MCP servers (FastMCP onboarding + prompt mgmt) — this is the production war-story. |
| 12:50 | 1454 | Too Many Agents: Deciding When to Use Agents, MCP Tools, Skills, Prompt or Just a Script | Decision framework for the exact tool sprawl (MCP, prompts, Bedrock automations) you're navigating. |
| 13:30 | 1429 | From Profiler to Production: React & React Native | Matches your daily Cisco reporting-UI React work; real perf metrics vs. vanity scores. |
| 14:10 | 1515 | Your Agent Just Ran rm -rf: Sandboxing AI Agents (Docker → GKE Agent Sandbox) | Security + agent tooling overlap (Cisco security work + your own coding-agent usage). |
| 14:50 | 1484 | Your AI Wrote the Code. Who Vouches for It? | Direct extension of your AI Code Review project (Bedrock/Claude/Jenkins). |
| 15:30 | 1523 | The Last Generation to Learn It the Hard Way: What Comes Next for Engineering in India | Panel on repositioning a long India engineering career as AI commoditizes delivery speed. |
| 16:10 | 1449 | Supply Chain Security for the Everyday Engineer | Maps to your "Secure Connectivity & Dependency Maintenance" work. |
| 16:50 | 1456 | We Deleted Our Observability Stack and Rebuilt It with OTEL (12→4 engineers, 20K+ clusters) | Matches your Observability & Reliability Engineering work (Splunk, Prometheus, PagerDuty). |

### Thursday 26 Nov

| Time | ID | Session | Why it fits |
|---|---|---|---|
| 10:00 | 1446 | Shipping MCP to Real Users: Scaling, Auth, and the PII Leak You Didn't See Coming | Near-exact overlap: MCP servers + PII cleaning for log exports, both things you've shipped. |
| 12:00 | 1452 | Did the Model Improve, or Just the Score? A Developer's Guide to LLM Evaluation | Relevant to evaluating your Bedrock/Claude AI code-review and bug-investigation prototypes. |
| 14:00 | 1479 | Stop Counting Tokens, Start Making Them Count | Cost side of the agentic tools (Bedrock, prompt management) you've shipped. |
| 14:40 | 1421 | Beyond File Dumps: Context Engineering for Coding Agents | Context-feeding strategy relevant to your RAG onboarding assistant. |
| 16:00 | 1427 | Enterprise AI Memory at Scale | Direct follow-on from your Bedrock Knowledge Bases + Titan embeddings onboarding assistant. |

### Session ids to paste into the WAD app

```
1539,1503,1457,1454,1429,1515,1484,1523,1449,1456,1446,1452,1479,1421,1427
```

## Runner-up alternatives (same time slot as a pick above)

- 10:50 Wed vs 1485 "Your Software Factory Never Sleeps" (GitHub agentic automations) — skipped, also strong.
- 11:30 Wed: 1419 "Autopsy of an Autonomous Incident", 1468 "Beyond vibe coding" (mainstage), 1420 "Beware of Strangers Bearing Code" — all strong, no pick made this slot to keep total ≤15.
- 12:10 Wed vs 1457: 1521 "Reviewing, Hosting, and Collaborating: Agentic Git Forge"
- 12:50 Wed vs 1454: 1436 "How We Cut Our API's p99 Latency"
- 13:30 Wed vs 1429: 1533 "Govern the runtime. Not the agent. (Docker)"
- 14:10 Wed vs 1515: 1478 "Ship Happens: Guardrails for AI-Written Code", 1461 "Architecting Secure and Encrypted Microservices in K8s"
- 14:50 Wed vs 1484: 1498 "From TypeScript to Go: How We Cut Infra Cost 26x"
- 15:30 Wed vs 1523: 1516 "Your AI Agents Are Bleeding Tokens", 1455 "ULTRON: Your Agent Has No Hands"
- 16:10 Wed vs 1449: 1462 "From Monolith to Phases: Restructuring Terraform Deployments"
- 16:50 Wed vs 1456: 1442 "Prompt Debt: Why Your AI System Is Frozen in Time" (also matches your Prompt Management project)
- 10:00 Thu vs 1446: 1435 "How is SWE & EM roles are changing in the age of AI", 1438 "Java is Coming for Python's Lunch"
- 12:00 Thu vs 1452: 1538 "Panel: AI in Production - What It Takes to Ship"
- 14:00 Thu vs 1479: 1471 "Decision models for developers who use LLMs"
- 14:40 Thu vs 1421: 1528 "Panel: Rebuilding Engineering Around Agents"
- 16:00 Thu vs 1427: 1506 "Spring Boot Beyond the Defaults" (matches your Spring background), 1499 "IAM as a Platform Service"

## Workshops worth booking separately (limited seats, book in the WAD app)

- [1467] Beyond Vibe Coding: Mastering SDD with Google Antigravity & Cloud Run MCP — Wed 10:50-12:50, Room 9
- [1448] Speed or Security? Why Not Both for Your Coding Agents (Docker) — Wed 13:15-15:15, Room 5
- [1524] Build Otto: Ship an AI Agent Without Redeploying (LaunchDarkly) — Wed 15:30-17:30, Room 5
- [1470] CI. CD. AI. Welcome to Continuous AI — Thu 12:30-14:30, Room 6 (fits your release/CI-CD automation work)
- [1497] From Spring Boot to Spring AI: A Java Developer's Journey into Agentic Systems — Thu 15:10-17:10, Room 7 (exact match to your Java/Spring stack)

## Research notes (background reading before the talks)

- [mcp-in-production.md](mcp-in-production.md) — sessions 1457, 1446
- [agentic-sdlc-and-agent-tool-sprawl.md](agentic-sdlc-and-agent-tool-sprawl.md) — sessions 1503, 1454
- [ai-agent-security-and-sandboxing.md](ai-agent-security-and-sandboxing.md) — sessions 1515, 1449
- [ai-code-trust-and-review.md](ai-code-trust-and-review.md) — session 1484
- [observability-and-sre-for-ai-systems.md](observability-and-sre-for-ai-systems.md) — session 1456
- [context-engineering-and-tokenomics.md](context-engineering-and-tokenomics.md) — sessions 1421, 1479
- [enterprise-ai-memory-and-llm-evaluation.md](enterprise-ai-memory-and-llm-evaluation.md) — sessions 1427, 1452
- [react-performance.md](react-performance.md) — session 1429
- [career-and-leadership-ai-era.md](career-and-leadership-ai-era.md) — session 1523
