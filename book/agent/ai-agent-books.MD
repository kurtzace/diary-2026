Tom Taulli (Aisera) and Gaurav Deshmukh (tata exili/AmAgLab)
Building Generative AI Agents
Using LangGraph, AutoGen, and CrewAI

5 hours


AI agents components. They include reflection (ability of a system to inspect and adjust its own cognitive processes.) , tools, memory, planning, multi-agent collaboration, and autonomy


## Agent Examples: 
ALFWorld is a benchmark environment for evaluating embodied AI agents through text-based household tasks. It pairs interactive text games with simulated 3D environments, requiring agents to follow natural-language instructions, plan actions, and manipulate objects to complete goals such as finding, cleaning, heating, or placing items.

AWS's Solution Architect Agent is an AI assistant designed to help plan and review cloud architectures on Amazon Web Services. It can interpret application requirements, recommend suitable AWS services, explain design trade-offs, identify reliability, security, performance, and cost considerations, and suggest improvements aligned with the AWS Well-Architected Framework. It supports architects by accelerating research and documentation, while human experts remain responsible for validating decisions and implementation details.

Salesforce's Einstein GPT is a generative AI assistant for CRM workflows. It creates personalized content, summarizes records, and provides insights across sales, service, marketing, and commerce using trusted Salesforce data.

JARVIS-1 is an autonomous AI agent designed to operate a computer through natural-language instructions. It can interpret goals, plan multi-step actions, use applications and tools, and adapt to feedback while completing tasks. Its actions should be monitored and constrained with appropriate permissions and safety checks.

Enso AI is an AI-agent platform that helps businesses automate repetitive knowledge-work tasks. Its agents can use company information and connected tools to research, analyze data, generate outputs, and support operational workflows. Enso emphasizes practical business outcomes, workflow integration, and human oversight so teams can review results, manage permissions, and remain accountable for important decisions.

TPTU (Task Planning and Tool Usage) is a framework for helping AI agents solve complex tasks by breaking goals into manageable steps and selecting the right tools for each step. It emphasizes planning, tool selection, structured execution, feedback, and replanning when results differ from expectations.

BabyAGI is an early autonomous-agent application that uses a language model to manage a task list. It creates tasks from a broad objective, prioritizes them, executes each task, and generates new tasks from the results. BabyAGI demonstrated how iterative planning and memory can extend an agent beyond a single response.

AutoGPT is an autonomous AI-agent application that breaks a high-level goal into smaller tasks and uses tools to pursue them with limited human guidance. It can reason through steps, search for information, create or modify files, and evaluate results before continuing. Its flexibility requires careful permissions, monitoring, and validation.

Asana uses AI to help teams manage projects and coordinate work. Its intelligent features can summarize tasks and updates, identify risks or blockers, generate status reports, suggest next steps, and help turn goals into organized plans. By connecting conversations, responsibilities, and deadlines, Asana AI helps teams reduce administrative work and keep projects moving.




## Long-term Memory

Long-term memory enables an agent to retain information beyond a single interaction and use it to improve future decisions:

- **Episodic memory:** Records specific events and past experiences, helping the agent recall what happened and apply lessons to similar situations.
- **Semantic memory:** Stores general knowledge, facts, concepts, relationships, and procedures. It supports reasoning about a domain, even when the agent encounters unfamiliar scenarios.
- **Procedural memory:** Preserves learned skills and task instructions, focusing on how to perform an action rather than remembering a particular event.

## Model types
- Autoregeesive - GPT - next token
- Autoencoding - BERT - surround context - bidirect
- Combines: T5
- Transfer learning
- Reinforcement Learning from Human Feedback (RLHF)
- Multimodal: sora, Deepmind flamingo, MS Kosmos
- Proprietary LLMs

| Topic | Advantage | Disadvantage |
| --- | --- | --- |
| Financial resources | Strong investment supports advanced models and infrastructure. | Access may depend on a paid subscription or usage fees. |
| Model capabilities | Often provides high performance, reliable quality, and frequent improvements. | Users have limited control over model behavior and updates. |
| API ecosystem | Mature APIs, tools, documentation, and integrations accelerate development. | API changes, outages, or limits can disrupt applications. |
| Cost and infrastructure | Hosted services remove the need to buy and maintain specialized hardware. | High-volume usage can become expensive, and pricing may change. |
| Support | Professional support and detailed documentation are often available. | Support quality and response times may depend on the service tier. |
| Privacy and security | Providers commonly offer security controls and compliance features. | Sensitive data is shared with an external provider and may create privacy risks. |
| Customization | Fine-tuning, prompting, and retrieval can adapt the model to specific needs. | Customization may be restricted compared with self-hosted or open models. |
| Vendor dependency | A managed platform simplifies deployment and ongoing maintenance. | Switching providers can be difficult because of lock-in and migration costs. |





## Behind scenes
OpenAI - licensed content-  News Corp, Springer, and Vox.

## Coding
Testing becomes a more nuanced concept with techniques like pairwise comparisons (e.g. Langsmith, Lmsys) and tracking improvements/regressions. 

Taylor moved from Facebook to founding Quip (docs compete) and later co-founded Sierra (Weight Watchers, Sonos, and OluKai), which builds secure AI agents for enterprise customer experiences.


## New Business strat
more likely that the business model will be based on the measurable improvements to productivity, cost savings, and effectiveness of the decision-making.

VC: Sequoia and Benchmark, NFX, Yossi Matias, Shmil Levy,