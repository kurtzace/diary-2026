# Agentic SDLC & Agent Tool Sprawl

## Overview

The 2024-2026 shift in professional software development is the move from "AI autocomplete inside an IDE" to autonomous or semi-autonomous agents that plan, edit, test, and open pull requests across a whole repo with limited supervision — what the industry now calls the "agentic SDLC." GitHub Copilot's evolution (chat → agent mode → background coding agents) and competing stacks (Claude Code, Cursor agents, Google Antigravity, Amazon Kiro/Bedrock agents) are the concrete instances of this. The open problem this conference keeps returning to is not "can an agent code" but "how do you govern, trust, and not over-engineer the agent layer" — teams are now over-correcting by wrapping every task in an "agent" when a cron job, a script, or a single prompt would be safer, cheaper, and easier to debug.

## Sessions

**[1503] From the IT Revolution to the Agentic Era** — Thomas Dohmke, Naresh Choudhary, Pratyush Kumar · Wed 10:10-10:40 · Mainstage keynote.
Dohmke was GitHub's CEO through the Copilot era (2021-2025) and left to co-found/lead a new venture billed on this agenda as "Entire." I could not independently verify "Entire"'s specifics via web search in this pass (search tools returned only CAPTCHA/empty results) — treat its product focus as unconfirmed until he says it from the stage. The likely thesis, consistent with his GitHub-era public statements, is that Indian developers are adopting agentic workflows faster than the IDE-centric world adapted its processes to match — i.e., the bottleneck is now review, trust and org process, not model capability. Good opener for framing the whole two days.

**[1454] Too Many Agents: Deciding When to Use Agents, MCP Tools, Skills, Prompt or Just a Script** — Suriyaa Thiyagarajan · Wed 12:50-13:20 · Stage 4.
Direct rebuttal to "agent-maximalism." Expect a decision tree along these lines: deterministic, bounded, repeatable task → plain script/cron; task needs an LLM's judgment but no multi-step tool use → a single prompt or "skill"; task needs the LLM to call external tools/data but is single-turn → MCP tool call; task needs multi-step autonomous planning, retries, and recovery → an actual agent loop. Listen for what signals ("needs autonomy," "needs memory across steps," "needs to call other agents") he uses to justify stepping up a tier, since that's the reusable part.

## Vocabulary to know going in

- **Agentic SDLC** — software lifecycle stages (plan, code, test, review, deploy) delegated to AI agents rather than performed by a human and merely assisted by AI.
- **MCP (Model Context Protocol)** — the open protocol (Anthropic-originated, now broadly adopted) for exposing tools/data to any LLM client; you've already shipped two MCP servers.
- **Skill / prompt library** — a reusable, versioned instruction set invoked without full agent autonomy — the tier below "agent" in the 1454 decision tree.
- **Agent sprawl** — the anti-pattern of wrapping simple logic in an agent loop, paying for extra latency/cost/non-determinism with no corresponding benefit.

## Connects to your work

You already have live instances of every tier in 1454's framework: the FastMCP onboarding agent and the Bedrock-backed prompt-management MCP tool (agent/MCP tier), the LangGraph-based JSON/CSV compatibility + filter-test automation for backend modernization (graph/agent tier), and the Langflow-based AI-assisted bug-investigation prototype (workflow tier, probably over-agent-ified by the standards this talk will set). Go in with a concrete question: would 1454's framework reclassify any of those down a tier?

Sources: WeAreDevelopers Conference India 2026 agenda (event id 19); general knowledge of GitHub Copilot/agent-mode history and MCP adoption through Jan 2026. Live web search for "Entire" (Dohmke's new company) did not return usable results in this pass — verify from the keynote itself.
