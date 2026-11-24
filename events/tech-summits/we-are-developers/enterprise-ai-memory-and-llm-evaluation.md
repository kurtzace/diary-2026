# Enterprise AI Memory & LLM Evaluation

## Overview

LLMs are stateless: every call starts from zero unless you explicitly feed context back in. The naive fix — replaying the entire conversation history on every turn — works for a demo and collapses at enterprise scale: token costs balloon, latency climbs, and the context window eventually overflows. "Agent memory" is the engineering layer that replaces raw replay with something cheaper and more durable: session summarization, long-term fact/preference stores, and retrieval (vector search) over past interactions instead of re-sending them verbatim.

A separate but related problem: once you build these systems, how do you know a change actually made them better? LLM evaluation is notoriously easy to fool yourself with — a model can be functionally correct but score zero against a benchmark because of wording, or a fine-tune can raise a benchmark number without improving real user outcomes (Goodhart's law applied to AI).

## The sessions

- **[1427] Enterprise AI Memory at Scale** — Aditya Joshi, Thu 16:00-16:30, Stage 4. Premise: agents don't remember by default; replaying full history "burns tokens" and doesn't scale. Expect coverage of summarization-on-session-end, memory identifiers per user, and retention/storage tradeoffs.
- **[1452] Did the Model Improve, or Just the Score? A Developer's Guide to LLM Evaluation** — Jack Fitzsimons, Thu 12:00-12:30, Stage 1 (IBM), live coding. Premise: exact-match scoring punishes correct-but-differently-worded answers, and fine-tuning gains don't always transfer to production.

## Key concepts

- **Session summarization vs. full replay** — compress a finished session into a summary (Bedrock Agents' memory does this automatically via an LLM-generated summary per session, keyed by `memoryId`, retained up to 365 days) instead of resending raw transcripts.
- **memoryId / sessionId** — the identifiers that scope whose history gets loaded back in; get this wrong and you leak one user's memory into another's context.
- **Vector-store memory** — retrieval over embedded past facts/interactions (what your onboarding assistant already does for documents, but applicable to conversation memory too).
- **Benchmark vs. product eval** — "benchmarks are like school exams, product evals are like job performance reviews" — a model choice benchmark is not a fitness-for-your-use-case test.
- **Exact-match vs. semantic/LLM-judged scoring** — rigid string matching fails on open-ended answers; semantic similarity or an LLM-as-judge is usually closer to what you actually care about.
- **Held-out test sets** — keep some eval examples untouched until you're done iterating, or you overfit your own eval.
- **Online eval / production observability** — the job isn't done at the offline benchmark; regressions show up live and need monitoring.

## Connects to your work

- Your Bedrock Knowledge Bases + Titan embeddings onboarding assistant *is* an enterprise memory system (retrieval over meeting chats/PDFs/webpages) — 1427 is effectively a session on the pattern one layer up (conversational memory, not just document retrieval). Worth comparing: are you summarizing/expiring stale context, or just growing the index indefinitely?
- Your AI code review (Bedrock/Claude/Jenkins) and AI-assisted bug investigation (Langflow) prototypes were judged informally ("did this actually help"). Against 1452's framing, three concrete gaps worth checking: (1) are you using exact-match-style pass/fail anywhere a semantic/LLM-judge comparison would be fairer; (2) do you have a held-out set of past bugs/PRs you never tuned prompts against, to sanity-check real improvement; (3) do you have any production-side signal (did the human reviewer actually accept the AI's suggestion) feeding back into whether the tool is improving, rather than relying solely on a one-time offline check.

Sources: AWS Bedrock Agents memory docs (docs.aws.amazon.com/bedrock/latest/userguide/agents-memory.html); Evidently AI LLM evaluation guide (evidentlyai.com/llm-guide/llm-evaluation).
