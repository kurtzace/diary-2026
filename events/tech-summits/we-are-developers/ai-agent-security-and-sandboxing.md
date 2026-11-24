# AI Agent Security & Sandboxing

Pre-reading for two WeAreDevelopers Conference India 2026 talks (Wed 25 Nov).

## Overview

Coding agents now run shell commands, install dependencies, and touch live
infrastructure on their own initiative — which turns two older problems into
one. The first is **blast-radius containment**: a plain container shares the
host kernel, so a rogue `rm -rf` or a leaked credential inside the container
can still escape to the node. The industry's answer is microVM-based
sandboxes (own kernel, own private daemon) instead of process-level
isolation. The second is **supply-chain trust**: the dependencies an agent
(or a human) pulls in are themselves an attack surface, and malicious
packages that hijack a popular library's install hooks or runtime are a
recurring npm/PyPI pattern. Both talks are really about the same question —
"how much do you trust code you didn't write, running with your
permissions?" — from two different angles: runtime isolation vs. dependency
hygiene.

## The sessions

- **[1515] Your Agent Just Ran rm -rf: Sandboxing AI Agents from Docker to GKE Agent Sandbox** — Rajani Ekunde, Wed 14:10-14:40, Stage 2. Argues plain containers are insufficient for untrusted agent execution and walks through Docker Sandboxes and Google's GKE Agent Sandbox as stronger isolation layers.
- **[1449] Supply Chain Security for the Everyday Engineer** — Pradumna Saraf, Wed 16:10-16:40, Stage 3 (GitHub-powered). Opens with an npm "Axios" compromise where bad versions allegedly shipped a hidden dependency pulling a remote access trojan onto Linux/macOS/Windows. I could not independently verify this specific incident (date, CVE, affected versions) via the sources I could reach — treat the teaser's details as the speaker's claim to confirm live, not a fact I've confirmed. The broader pattern of npm packages being hijacked via maintainer-account takeover or malicious transitive dependencies is well documented industry-wide.

## Key concepts to know going in

- **Docker Sandboxes** — confirmed via Docker's own blog: each sandbox runs as a microVM with its own kernel and a private Docker Engine (not a shared-kernel container), giving VM-level isolation. They support shared mounts, git-worktree, or full-clone code organization, plus sandbox policies, MCP tool governance, network controls, and audit visibility — i.e., built specifically to contain agents, not just processes.
- **GKE Agent Sandbox** — Google Cloud's equivalent sandboxing primitive for running agents on GKE; I couldn't pull current official documentation to confirm specifics, so verify the isolation mechanism (likely gVisor/Kata-style microVM or similar) live in the talk rather than from this note.
- **Supply-chain attack vectors for npm/PyPI**: typosquatting, maintainer account takeover, malicious install/postinstall scripts, dependency confusion, and compromised transitive dependencies are the recurring categories — a "hidden dependency" delivering a RAT fits the compromised-transitive-dependency pattern.
- **SBOM (Software Bill of Materials)** — likely to come up as the practical defense: knowing exactly what's in your dependency tree before an agent (or CI) installs it.

## Connects to your work

You maintain cybersecurity reporting (SSE/Umbrella) at Cisco and have shipped
"Secure Connectivity & Dependency Maintenance" work (Java/Kotlin, Bouncy
Castle, AWS RDS, EKS, Helm, Terraform, dependency upgrades) — plus you use
coding agents day to day. Two concrete things to check against your own
setup after these talks:

1. What isolation boundary do your own coding-agent sessions actually run
   in — a shared-kernel container, your host shell, or something sandboxed?
   If it's the former, 1515 is a direct argument for upgrading that.
2. Does your dependency-upgrade workflow (the EKS/Helm/Terraform pipeline)
   pin and verify transitive dependencies, or would a malicious postinstall
   script in a routine `npm`/`pip` bump slip through unnoticed? 1449's
   SBOM-style practices are the cheap fix to validate.
