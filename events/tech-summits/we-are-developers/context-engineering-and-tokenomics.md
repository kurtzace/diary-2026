# Context Engineering & Tokenomics for Coding Agents

## Overview

"Context engineering" is the successor discipline to prompt engineering: instead of
crafting one good instruction, you curate the *entire* token environment an agent sees
across a multi-turn session — system prompt, tool definitions, retrieved files, prior
turns. The core problem is "context rot": transformer attention degrades as context
grows, so every token has a real (and quadratic) cost in both accuracy and money.
Practically this means treating context as a scarce resource with diminishing returns,
not a dumping ground. On the cost side, as coding agents move to usage-based billing,
the naive fix (shorten prompts, count tokens) misses the bigger levers: caching, "just
in time" retrieval instead of pre-loading everything, context compaction, and routing
work to cheaper models where a frontier model isn't needed.

## Sessions

- **[1421] Beyond File Dumps: Context Engineering for Coding Agents** — Animesh Dutta,
  Thu 14:40-15:10, Stage 1 (IBM). Argues that pasting raw files/stack traces/half a repo
  is the default failure mode; the fix is deliberate context curation.
- **[1479] Stop Counting Tokens, Start Making Them Count** — Vicky Israni, Thu 14:00-14:30,
  Stage 1 (IBM), live coding. Reframes agent cost from "shorter prompts" to "cost per
  successful outcome."

## Key concepts to know going in

- **Context rot** — accuracy degrades as context window fills, independent of whether
  the content is relevant.
- **Just-in-time retrieval** — agent holds lightweight pointers (file paths, IDs) and
  fetches content on demand, rather than front-loading everything.
- **Compaction** — summarizing and restarting a context window mid-task while preserving
  key decisions, for long-running agent sessions.
- **Structured note-taking / external memory** — agent writes persistent notes outside
  the context window instead of re-stating state every turn.
- **Multi-agent decomposition** — sub-agents do focused work and return condensed
  summaries, instead of one agent holding everything.
- **Model routing** — sending cheap/simple steps to small models, reserving frontier
  models for the steps that need them.

## Connects to your work

- Your **RAG onboarding assistant** (Bedrock Knowledge Bases + Titan embeddings, fed
  meeting chats/recordings/PDFs via S3) is a retrieval design, not a file-dump design —
  check whether it does true just-in-time retrieval per query or over-fetches context
  per call; that's the exact gap [1421] is likely to call out.
- Your **Bedrock Prompt Management** tool (shared/versioned prompts for code gen,
  testing, reviews) is squarely the "system prompt curation" layer these talks reference
  — worth comparing its versioning/tagging model against the "minimal sufficient
  context" principle.
- Neither project currently has a stated cost-per-outcome metric (vs. raw token counts) —
  [1479] gives you a framing to retrofit onto the Prompt Management and AI Code Review
  (Bedrock/Claude/Jenkins) tools.

Source consulted: Anthropic, "Effective context engineering for AI agents"
(anthropic.com/engineering/effective-context-engineering-for-ai-agents).
