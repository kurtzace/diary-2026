# Your AI Wrote the Code. Who Vouches for It?

## Overview

As coding agents move from autocomplete to autonomous PR authorship, the review bottleneck shifts
from "is this code good" to "can I trust the provenance of this code." Faster generation does not
reduce risk — it multiplies the number of unreviewed decisions (library choice, auth handling,
error paths) a human now has to vouch for. The industry response in 2025-2026 has been to bolt
audit and policy layers onto the PR itself: who prompted the agent, which tool calls it made,
what secrets it touched, and whether a human actually read the diff or just clicked approve.
GitHub in particular has been shipping adaptive-effort code review, secret scanning aimed at both
"developers and agents," repo-level tracking of review outcomes, and org-wide activity monitoring
(via Microsoft Agent 365) specifically so agent-authored PRs leave a trail distinguishable from
human ones. Source: github.blog/changelog (Copilot label, Nov 2025 entries).

## Session

**[1484] Your AI Wrote the Code. Who Vouches for It?**
Siddharth Joshi, Senior Customer Success Architect, GitHub — Wed 14:50-15:20, Stage 3
(GitHub-powered), LIVE CODING, track: Security & Privacy.
Why it matters: this is GitHub's own framing of the trust problem for agentic PRs — expect a
live demo of whatever their current "vouching" mechanism is (review outcome tracking, secret
detection, customization provenance), not just a think-piece.

## Key concepts / vocabulary

- **Review outcome tracking** — repo insights on whether Copilot review comments were addressed, accepted, or ignored.
- **Secret scanning for agents** — scanning triggered by agent tool calls, not just commits.
- **Copilot customization provenance** — controlling/knowing where an agent's instructions/rules came from.
- **Adaptive-effort review** — review depth that scales with change risk rather than being fixed.
- **Agent activity monitoring** (Microsoft Agent 365 integration) — org-level visibility into what an agent did across a session, not just the final diff.

## Connects to your work

You already built the other half of this stack: an **AI Code Review** pipeline at Cisco on
**Amazon Bedrock + Claude + GitHub + Jenkins**. Three comparisons worth making live at the talk:

1. Your pipeline presumably reviews a diff at CI time (Jenkins-triggered); GitHub's newer model
   tracks review *outcomes* over time per repo — ask whether outcome-tracking data is exportable
   so you could feed it back into your own Bedrock prompts as a feedback loop.
2. GitHub ties secret scanning directly to agent tool calls, not just the final commit — check
   whether your Bedrock/Claude reviewer sees anything earlier than the diff (e.g. intermediate
   agent actions), or only the end artifact like GitHub used to.
3. Ask Siddharth directly: for a non-GitHub-Copilot agent (your Bedrock/Claude setup) producing a
   PR, is there a way to attach GitHub's new provenance/outcome-tracking metadata so a third-party
   agent's work shows up with the same audit trail as Copilot's — that's the sharp, non-generic
   question this talk invites.
