# Codex Agent Notes

## Configuration and profiles

Use `config.toml` for operating defaults such as model behavior, sandboxing, approvals, environment policy, MCP servers, and optional features. Profiles let one installation switch between named configurations without rewriting global settings.

### Code snippet

```toml
# ~/.codex/config.toml
model = "gpt-5.4"
model_reasoning_effort = "high"
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[shell_environment_policy]
include_only = ["PATH", "HOME"]

[mcp_servers.github]
command = "github-mcp"

[profiles.work]
model_reasoning_effort = "medium"
```

```bash
codex --profile work
```

### Use for

- Stable personal defaults and named environment or workload configurations.
- Setting least-privilege execution, integrations, model behavior, and feature flags.

### Not for

- Repository instructions shared with collaborators; use `AGENTS.md`.
- Hard-coding secrets or passing the entire host environment to shell commands.

### References

- [Codex configuration](https://developers.openai.com/codex/config-basic)
- [Codex configuration reference](https://developers.openai.com/codex/config-reference)

----

## Prompt contracts

Give Codex a clear goal, context pointers, constraints, and a definition of done. This compact contract keeps work scoped, reviewable, and repeatable while giving the agent enough freedom to choose the implementation path.

### Code snippet

```text
Goal: Fix the catalog source, not generated output.
Context: Inspect catalog data, generator, and failing storefront pages.
Constraints: Preserve public APIs; do not edit generated files directly.
Done when: Catalog checks pass and affected pages are verified in a browser.
```

### Use for

- Any implementation, investigation, review, or repair with concrete acceptance criteria.
- Pointing Codex to relevant files and evidence without pasting all context into one prompt.

### Not for

- Stable repository conventions; put those in `AGENTS.md`.
- Reusable multi-step procedures; package those as skills.

### References

- [Codex Prompting Guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide)

----

## AGENTS.md layering

`AGENTS.md` gives Codex durable instructions for the files under its directory. Put exact commands, conventions, validation expectations, and hard boundaries near the top; use deeper files or `AGENTS.override.md` for intentional local differences.

### Code snippet

```text
~/.codex/AGENTS.md                         personal defaults
repo/AGENTS.md                             repository standards
repo/apps/web/AGENTS.md                    directory-specific guidance
repo/services/payments/AGENTS.override.md  intentional local override
```

```markdown
# Validation
- Run `npm run check` and the affected tests.
- Do not edit generated files; change their source and regenerate them.
```

### Use for

- Shared build commands, coding conventions, validation, and directory-specific constraints.
- Teaching Codex where generated files, source-of-truth data, and protected areas live.

### Not for

- A single task's outcome and acceptance criteria; put those in the prompt or goal.
- Live external facts, secrets, or long procedures better represented as skills.

### References

- [Custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md)

----

## Rules (`.rules`)

Rules define command-level policy, especially what Codex may run outside the sandbox and when approval is required. Keep patterns narrow and attach a justification so safety behavior remains understandable and reviewable.

### Code snippet

```starlark
# ~/.codex/rules/default.rules
prefix_rule(
    pattern = ["git", "push"],
    decision = "prompt",
    justification = "Confirm before publishing changes.",
)
```

### Use for

- Blocking dangerous command prefixes or requiring approval for pushes, deploys, and migrations.
- Expressing command policy that applies consistently across sessions.

### Not for

- Teaching repository behavior; use `AGENTS.md`.
- Expanding filesystem access; use sandbox and writable-root settings.
- Running commands automatically; use hooks or automations.

### References

- [Codex rules](https://developers.openai.com/codex/rules)

----

## Hooks (`/hooks`)

Hooks run deterministic commands at lifecycle events such as tool use, compaction, sub-agent start, or stop. They are useful for automatic policy checks, formatting, linting, testing, regeneration, and workflow bookkeeping.

### Code snippet

```toml
# ~/.codex/config.toml
[[hooks.PreToolUse]]
matcher = "^Bash$"

[[hooks.PreToolUse.hooks]]
type = "command"
command = "/usr/bin/python3 '$(git rev-parse --show-toplevel)/.codex/hooks/pre_tool_use_policy.py'"
timeout = 30
statusMessage = "Checking Bash command"
```

### Use for

- Running repeatable checks before or after tool calls and before completion.
- Formatting, testing, regeneration, audit logging, and deterministic policy enforcement.

### Not for

- Replacing rules, sandboxing, or approval boundaries for risky operations.
- Teaching repository context or embedding complex agent reasoning in shell scripts.

### References

- [Codex hooks](https://developers.openai.com/codex/hooks)

----

## Status line

Use `/statusline` to choose which session details Codex displays while a task runs. Model, branch, sandbox, and token information make long-running or parallel sessions easier to distinguish and monitor.

### Code snippet

```text
/statusline
```

### Use for

- Monitoring long-running sessions and comparing parallel sessions.
- Keeping the active model, branch, sandbox, or token usage visible.

### Not for

- Persisting project state or progress; use repository artifacts such as `status.md`.
- Controlling permissions; use sandbox settings, approvals, and rules.

### References

- [Codex CLI documentation](https://developers.openai.com/codex/cli)

----

## Context placement

Put each kind of context where its lifetime and audience belong. Keep one-off intent in the prompt, team conventions in `AGENTS.md`, operating defaults in `config.toml`, reusable procedures in skills, live state behind MCPs, and recurring work in automations.

### Code snippet

```text
Prompt       -> task intent and acceptance criteria
AGENTS.md    -> repository conventions and validation rules
config.toml  -> behavior, permissions, profiles, and MCP setup
Skill        -> reusable procedure with scripts or references
MCP          -> live external systems and approved data
Automation   -> scheduled or recurring work
```

### Use for

- Preventing oversized prompts and repeated rediscovery.
- Separating personal preferences, team rules, live evidence, and repeatable procedures.

### Not for

- Copying all available context into every turn.
- Storing time-sensitive facts in instructions or memory.

### References

- [Codex Prompting Guide](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide)
- [Agents Cookbook](https://developers.openai.com/cookbook/topic/agents)

----

## Skills

Skills package a proven procedure as instructions, scripts, templates, and assets that Codex loads only when relevant. They keep global prompts lean and make team workflows discoverable, testable, shareable, and independently versionable.

### Code snippet

```markdown
---
name: catalog-change
description: Update catalog source data, regenerate outputs, and verify pages.
---

# Catalog change
1. Edit the source data.
2. Run the generator and catalog checks.
3. Verify affected pages in the browser.
```

Invoke explicitly when needed:

```text
$catalog-change repair the malformed product descriptions
```

### Use for

- Frequent tasks with a known sequence, repository context, and reviewable output.
- Shared workflows such as release readiness, CI triage, documentation sync, and dependency upgrades.

### Not for

- One-off or highly exploratory work that needs continual steering.
- Time-based recurrence; use an automation to schedule the skill.
- Fetching live state or creating external side effects; use tools or MCP servers.

### References

- [Skills in OpenAI API](https://developers.openai.com/cookbook/examples/skills_in_api)
- [Skills documentation](https://developers.openai.com/api/docs/guides/tools-skills)

----

## Execution plans

Use a repository `PLANS.md` contract and a living ExecPlan for multi-hour features or significant refactors. The plan preserves purpose, milestones, decisions, discoveries, exact commands, progress, recovery steps, and observable acceptance evidence across handoffs.

### Code snippet

```markdown
# ExecPlans

When writing complex features or significant refactors, use an ExecPlan
(as described in `.agent/PLANS.md`) from design through implementation.
```

A useful plan keeps these sections current:

```markdown
## Purpose / Big Picture
## Progress
## Surprises & Discoveries
## Decision Log
## Plan of Work
## Validation and Acceptance
## Outcomes & Retrospective
```

### Use for

- Work spanning multiple hours, services, milestones, or context windows.
- Changes that another agent or engineer must be able to resume from repository files alone.

### Not for

- Small edits with an obvious implementation and validation path.
- A static up-front plan that is never updated as evidence changes.

### References

- [Using PLANS.md for multi-hour problem solving](https://developers.openai.com/cookbook/articles/codex_exec_plans)

----

## Goal mode

Goal mode attaches a durable objective to the current thread and lets Codex continue until an evidence-based exit condition is met. Strong goals define the outcome, verification surface, constraints, boundaries, iteration policy, and blocked stop condition.

### Code snippet

```text
/goal Reduce p95 checkout latency below 120 ms, verified by the checkout
benchmark, while keeping correctness tests green. Record each experiment.
If blocked, report attempted paths, evidence, and the input needed to continue.
```

```text
/goal pause
/goal resume
/goal clear
```

### Use for

- Long-running bug hunts, migrations, refactors, optimization, and research with measurable outcomes.
- Work where the next action depends on evidence from the previous attempt.

### Not for

- One-line edits, short reviews, vague exploration, or tasks Codex cannot verify.
- Sensitive work requiring close human steering at each step.

### References

- [Using Goals in Codex](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex)

----

## Sub-agents

Use `/agent` to delegate bounded work to specialized parallel threads, then synthesize their results in the main thread. Good delegation gives each worker a narrow objective, relevant context, expected artifact, and validation or handoff contract.

### Code snippet

```text
/agent Spawn scoped agents for UI, auth, database, and tests. Give each agent
its relevant files and acceptance criteria, then synthesize conflicts and results.
```

### Use for

- Independent research, review, implementation, or monitoring workstreams.
- Main-agent plus reviewer, orchestrator, or QA-agent execution patterns.

### Not for

- Isolating local Git branches; use Worktrees.
- Exploring an alternate path from the current task; use `/fork`.
- Tiny tasks where delegation overhead and extra tokens exceed the benefit.

### References

- [Parallel Agents with the OpenAI Agents SDK](https://developers.openai.com/cookbook/examples/agents_sdk/parallel_agents)
- [Building Consistent Workflows with Codex CLI and Agents SDK](https://developers.openai.com/cookbook/examples/codex/codex_mcp_agents_sdk/building_consistent_workflows_codex_cli_agents_sdk)

----

## Custom agents

Configure a custom agent only when a specialized role should repeat. Built-in sub-agents need no custom file; reusable personal roles live in `~/.codex/agents/`, while repository roles live in `.codex/agents/` and may override model, reasoning, sandbox, MCP, or skills.

### Code snippet

```toml
# ~/.codex/config.toml
[features]
multi_agent = true

[agents]
max_threads = 3
max_depth = 1

[agents.reviewer]
description = "Review completed work against acceptance criteria"
config_file = "agents/reviewer.toml"
```

```toml
# ~/.codex/agents/reviewer.toml
model_reasoning_effort = "medium"
developer_instructions = """
Review the prescribed scope. Report findings, evidence, unresolved risks,
and whether the acceptance criteria are satisfied. Do not edit files.
"""
```

### Use for

- Repeated specialist roles with stable instructions and tool boundaries.
- Reviewers, migration planners, security analysts, or domain-specific implementers.

### Not for

- A role used once; describe it in the delegation prompt instead.
- Unbounded agent trees; each role adds tokens, tool calls, and coordination cost.

### References

- [Building Consistent Workflows with Codex CLI and Agents SDK](https://developers.openai.com/cookbook/examples/codex/codex_mcp_agents_sdk/building_consistent_workflows_codex_cli_agents_sdk)

----

## Memory and compaction

Memory carries stable preferences and reusable workflow lessons across runs; compaction preserves the active working state when one long thread grows. Keep case facts, decisions, citations, and handoff state in reviewed repository artifacts rather than either mechanism.

### Code snippet

```toml
[features]
memories = true
```

```text
/memories
/compact
```

### Use for

- Memory: personal preferences, prior corrections, and stable process lessons.
- Compaction: long-running threads approaching context limits or meaningful phase boundaries.

### Not for

- Team rules; use `AGENTS.md`.
- Project truth, investigation conclusions, or durable handoffs; use repository artifacts.
- Compacting after every turn without context pressure or a phase boundary.

### References

- [Building Reliable Agents with Memory and Compaction](https://developers.openai.com/cookbook/examples/agents_sdk/building_reliable_agents_memory_compaction)
- [Codex Prompting Guide: Compaction](https://developers.openai.com/cookbook/examples/gpt-5/codex_prompting_guide#compaction)

----

## Live context with MCP

Use MCP servers and connectors when the source of truth changes frequently or lives outside the repository. Give Codex source precedence and escalation rules so it stops when required context is missing, stale, or contradictory instead of silently guessing.

### Code snippet

```toml
[mcp_servers.github]
command = "github-mcp"
```

```markdown
## Live context rules
- Treat the issue tracker as the source of truth for acceptance criteria.
- Escalate when the ticket and repository specification conflict.
- Do not proceed when required source data is missing or stale.
```

### Use for

- Tickets, wikis, databases, source-control systems, logs, and current documentation.
- Pulling approved, time-bound evidence into a task without copying it into prompts.

### Not for

- Stable team conventions; use `AGENTS.md`.
- Long reusable procedures; use skills.
- Broad access when a narrower read-only connector is sufficient.

### References

- [Building a coding agent with web, shell, patch, and MCP tools](https://developers.openai.com/cookbook/examples/build_a_coding_agent_with_gpt-5.1)
- [Multi-tool orchestration with RAG](https://developers.openai.com/cookbook/examples/responses_api/responses_api_tool_orchestration)

----

## Worktrees

Git worktrees create separate local directories attached to separate branches. They let multiple Codex sessions implement features, fixes, or experiments in parallel without changing branches or competing over one checkout.

### Code snippet

```bash
git worktree add ../<branch-name> -b <branch-name>
```

### Use for

- Working on multiple branches locally or running parallel sessions on isolated checkouts.
- Keeping experimental, feature, and bug-fix changes physically separated.

### Not for

- Exploring a separate conversational approach; use `/fork`.
- Splitting analysis within one task; use sub-agents.

### References

- [Git worktree documentation](https://git-scm.com/docs/git-worktree)

----

## Forking

Use `/fork` to branch the current Codex task into an independent path while preserving the starting context. It is useful for testing alternate implementations or risky ideas without disrupting the original thread.

### Code snippet

```text
/fork <alternate approach>
```

### Use for

- Comparing two approaches or prototyping a risky implementation.
- Preserving the main task while exploring a different reasoning and execution path.

### Not for

- Running local branches side by side; use Worktrees.
- Delegating independent parts of one solution; use sub-agents.

### References

- [Codex CLI documentation](https://developers.openai.com/codex/cli)

----

## Verification contracts

A verification contract states the checks and evidence Codex must produce before declaring work complete. Combine task acceptance criteria with repository standards, automated checks, runtime behavior, visual inspection, diff review, and escalation conditions.

### Code snippet

```markdown
## Verification
Before finishing:
- Run `npm run check && npm test`.
- Start the app and verify the affected flow in the browser.
- Review the diff for regressions and unrelated edits.
- Report commands, outcomes, remaining risks, and any skipped checks.
```

### Use for

- Defining observable completion for implementation, migration, and repair work.
- Requiring evidence from tests, builds, APIs, logs, screenshots, or reviewer passes.

### Not for

- Treating compilation or one passing test as proof of full behavior.
- Checks the environment cannot execute without an explicit escalation or fallback.

### References

- [Using Goals in Codex](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex)
- [Using PLANS.md for multi-hour problem solving](https://developers.openai.com/cookbook/articles/codex_exec_plans)

----

## Iterative repair loops

Closed-loop work separates review, repair, and validation. Each pass makes focused changes, records evidence, and feeds the remaining validation delta into the next pass until checks succeed, progress stalls, the attempt budget is reached, or human review is required.

### Code snippet

```text
Review current artifact -> structured findings
Repair smallest useful scope -> changed artifact
Validate behavior -> pass or remaining delta
Repeat remaining delta -> next repair
```

```json
{
    "review": [{"issue_type": "deprecated_api", "severity": "high"}],
    "repair": {"changes_made": ["Updated the API call"]},
    "validation": {"passed": false, "remaining_delta": ["Fix setup docs"]}
}
```

### Use for

- Modernization, flaky-test repair, documentation maintenance, and policy or schema remediation.
- Work where runtime feedback is more trustworthy than a single subjective review.

### Not for

- Unbounded retries without attempt limits, convergence checks, or escalation.
- Repairs without a deterministic or reviewable validation surface.

### References

- [Build iterative repair loops with Codex](https://developers.openai.com/cookbook/examples/codex/build_iterative_repair_loops_with_codex)

----

## Codex as an MCP server

Run Codex CLI as a long-lived MCP server when another agent system must delegate coding work to it. The server exposes tools for starting and continuing Codex conversations, allowing an orchestrator to gate handoffs on artifacts and acceptance evidence.

### Code snippet

```python
from agents.mcp import MCPServerStdio

async with MCPServerStdio(
        name="Codex CLI",
        params={"command": "npx", "args": ["-y", "codex", "mcp-server"]},
        client_session_timeout_seconds=360000,
) as codex_mcp_server:
        ...
```

### Use for

- Agents SDK orchestration where specialized roles hand scoped implementation to Codex.
- Repeatable pipelines that need artifact gates, long timeouts, and traceable handoffs.

### Not for

- Normal interactive CLI work where direct Codex use is simpler.
- Giving an orchestrator unrestricted write access without sandbox and approval boundaries.

### References

- [Building Consistent Workflows with Codex CLI and Agents SDK](https://developers.openai.com/cookbook/examples/codex/codex_mcp_agents_sdk/building_consistent_workflows_codex_cli_agents_sdk)

----

## Traces and eval-driven improvement

Traces capture prompts, tool calls, handoffs, timing, errors, and artifacts; evals turn recurring reviewer feedback into durable regression checks. Feed trace evidence, human judgment, and eval outcomes into a reviewed Codex handoff instead of relying on prompt tweaks alone.

### Code snippet

```text
Traces -> human/model feedback -> reusable evals -> validation gate
             -> ranked harness changes -> Codex implementation -> rerun evals
```

```json
{
    "eval": "public API remains unchanged",
    "passed": false,
    "evidence": "route signature changed",
    "next_change": "restore compatibility and add a regression test"
}
```

### Use for

- Debugging multi-agent coordination and measuring real workflow behavior.
- Preserving lessons from failures as tests before changing prompts, tools, routing, or policies.

### Not for

- Collecting sensitive traces without appropriate retention and access controls.
- Optimizing against weak or unreviewed evals that do not represent user outcomes.

### References

- [Build an Agent Improvement Loop with Traces, Evals, and Codex](https://developers.openai.com/cookbook/examples/agents_sdk/agent_improvement_loop)
- [Macro Evals for Agentic Systems](https://developers.openai.com/cookbook/examples/partners/macro_evals_for_agentic_systems/macro_evals_for_agentic_systems)

----

## Automations

Automations schedule recurring Codex work, often by invoking a stable skill on a cadence. Keep the procedure in the skill and the timing in the automation so each can evolve independently and every run can produce reviewable artifacts and evidence.

### Code snippet

```text
Schedule: weekdays at 09:00
Workflow: run $ci-failure-triage
Output: status.md with failures, owners, evidence, and escalation items
```

### Use for

- Daily triage, documentation refreshes, dependency scans, and recurring readiness checks.
- Stable workflows with predictable inputs, outputs, and escalation conditions.

### Not for

- A procedure that is still changing or requires frequent interactive steering.
- Hiding production side effects; keep approvals and safety gates explicit.

### References

- [Agents Cookbook](https://developers.openai.com/cookbook/topic/agents)