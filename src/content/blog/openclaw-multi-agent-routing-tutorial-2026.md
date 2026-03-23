---
title: "How to Run Multiple AI Personalities on One Server With OpenClaw"
description: "OpenClaw's multi-agent routing lets you host completely isolated AI personas — different brains, different channels, different memories — on a single Gateway. Here's a hands-on tutorial."
pubDate: "Mar 19 2026"
tags: ["ai", "openclaw", "tutorial", "agents", "open-source"]
---

Most AI agent setups give you exactly one brain. One personality. One set of memories. If you want a coding assistant *and* a social media manager *and* a customer support bot, you're spinning up three separate services, managing three sets of credentials, and praying they don't step on each other.

[OpenClaw](https://github.com/openclaw/openclaw) solved this problem with something deceptively elegant: multi-agent routing. One Gateway process. Multiple fully isolated AI personas. Each with its own workspace, memory, personality, skills, and channel bindings. No cross-contamination. No shared context leaks.

This isn't theoretical. I'm going to walk you through setting it up from scratch.

## Why You'd Want Multiple Agents

Before we get into the how, let's talk about why this matters.

**Scenario 1: Work and personal separation.** You want an AI assistant for your day job — coding, email triage, meeting prep. But you also want one for personal stuff — smart home control, recipe suggestions, travel planning. These shouldn't share context. Your work assistant doesn't need to know about your dinner plans, and your personal assistant doesn't need access to your company's codebase.

**Scenario 2: Multiple people, one server.** You've got a Mac mini running [OpenClaw](https://docs.openclaw.ai) in the closet. Your partner wants their own AI assistant. Your kid wants a homework helper. Each person deserves isolated conversations that the others can't accidentally (or intentionally) access.

**Scenario 3: Specialized personas.** A sharp, no-nonsense coding agent that communicates via Discord. A warm, patient customer-facing bot on Telegram. A chaotic creative writing partner on WhatsApp. Same Gateway, completely different personalities.

This is what OpenClaw's multi-agent architecture was built for.

## What "One Agent" Actually Means

In OpenClaw's architecture, an **agent** isn't just a prompt template. It's a fully scoped entity with its own:

- **Workspace**: files, `SOUL.md` (personality), `AGENTS.md` (behavior rules), `USER.md` (who they're helping), local notes, and project files.
- **State directory** (`agentDir`): auth profiles, model registry, per-agent config. Lives at `~/.openclaw/agents/<agentId>/agent`.
- **Session store**: completely separate chat history and routing state under `~/.openclaw/agents/<agentId>/sessions`.
- **Skills**: per-workspace skill folders, plus shared skills from `~/.openclaw/skills`.

This is full isolation. Agent A literally cannot see Agent B's conversations, memories, or files unless you explicitly configure it. Auth profiles are per-agent. Sessions are per-agent. Even the model configuration can differ — Agent A on Claude Opus, Agent B on GPT-5, Agent C on a local Llama model.

When you run OpenClaw without configuring anything, you get a single agent with `agentId: "main"`. That's the default most people use. But the architecture was designed from day one to support many.

## Step 1: Create Your Agents

OpenClaw ships with a wizard that handles the boilerplate:

```bash
openclaw agents add coding
openclaw agents add social
openclaw agents add family
```

Each command creates:
- A new workspace at `~/.openclaw/workspace-<agentId>`
- A state directory at `~/.openclaw/agents/<agentId>/agent`
- A session store at `~/.openclaw/agents/<agentId>/sessions`
- Starter files: `SOUL.md`, `AGENTS.md`, `USER.md`

The wizard asks a few questions about personality and model preferences. Answer them or accept defaults — you can always edit the files later.

## Step 2: Give Each Agent a Soul

This is the fun part. Each agent's `SOUL.md` defines who they are. Here's what I use for a coding agent:

```markdown
# SOUL.md - Coding Agent

You're a senior engineer. Terse. Precise. No fluff.
When you write code, it compiles on the first try.
When you explain something, you assume the reader is competent.
You have opinions about architecture and you're not afraid to share them.
Preferred response style: code first, explanation second.
```

And for a social/creative agent:

```markdown
# SOUL.md - Social Agent

You're creative, warm, and a little chaotic.
You love brainstorming and riffing on ideas.
You use metaphors freely and aren't afraid of tangents.
When someone asks for help with writing, you match their voice, not yours.
```

These aren't just prompts. They're loaded into the agent's context on every session start, alongside `AGENTS.md` (which defines behavior rules, safety boundaries, and tool usage patterns) and `USER.md` (which tells the agent about the person they're helping).

The workspace also contains `MEMORY.md` for long-term memory and a `memory/` directory for daily notes. Each agent maintains its own memories independently. Your coding agent remembers that you prefer TypeScript over JavaScript. Your social agent remembers your writing style preferences. They don't cross-pollinate.

## Step 3: Set Up Channel Accounts

Each agent needs its own channel identity. On Discord, that means a separate bot token. On Telegram, a separate BotFather bot. On WhatsApp, a separate phone number or session.

```bash
# Link a WhatsApp account for the coding agent
openclaw channels login --channel whatsapp --account coding-wa

# Link a Discord bot for the social agent
openclaw channels login --channel discord --account social-discord

# Link a Telegram bot for the family agent
openclaw channels login --channel telegram --account family-tg
```

The key insight: OpenClaw supports **multiple accounts per channel type**. You can have two WhatsApp numbers, three Discord bots, and a Telegram bot all running on the same Gateway process. No separate services. No port conflicts.

## Step 4: Wire It Together With Bindings

Bindings are how OpenClaw knows which inbound messages go to which agent. They live in your `openclaw.json` config:

```json5
{
  agents: {
    list: [
      {
        agentId: "coding",
        workspace: "~/.openclaw/workspace-coding",
        model: "anthropic/claude-opus-4"
      },
      {
        agentId: "social",
        workspace: "~/.openclaw/workspace-social",
        model: "anthropic/claude-sonnet-4"
      },
      {
        agentId: "family",
        workspace: "~/.openclaw/workspace-family",
        model: "google/gemini-2.5-pro"
      }
    ],
    bindings: [
      {
        agentId: "coding",
        channel: "discord",
        accountId: "coding-discord"
      },
      {
        agentId: "social",
        channel: "whatsapp",
        accountId: "social-wa"
      },
      {
        agentId: "family",
        channel: "telegram",
        accountId: "family-tg"
      }
    ]
  }
}
```

Each binding maps a `(channel, accountId)` pair to an `agentId`. Messages arriving on the coding Discord bot go to the coding agent. Messages on the family Telegram bot go to the family agent. Clean, declarative routing.

## Advanced: One Account, Multiple Agents (DM Splitting)

Here's where it gets interesting. What if you only have one WhatsApp number but want different people routed to different agents?

OpenClaw supports **peer-based binding**. You match on the sender's phone number:

```json5
{
  agents: {
    bindings: [
      {
        agentId: "partner",
        channel: "whatsapp",
        peer: { kind: "direct", id: "+15551234567" }
      },
      {
        agentId: "kid",
        channel: "whatsapp",
        peer: { kind: "direct", id: "+15559876543" }
      }
    ]
  }
}
```

When your partner messages the WhatsApp number, they get routed to the "partner" agent with its own personality and memory. Your kid gets routed to the "kid" agent. Same phone number, completely different experiences.

Combine this with `session.dmScope: "per-channel-peer"` to ensure DM sessions are fully isolated per user:

```json5
{
  session: {
    dmScope: "per-channel-peer"
  }
}
```

Without this, all DMs share the same session context — which means Bob could accidentally see what Alice was talking about. With `per-channel-peer`, each sender gets their own isolated conversation thread. This is critical for any multi-user setup.

## Step 5: Per-Agent Skills

Skills are OpenClaw's way of teaching agents how to use specific tools. They're [AgentSkills](https://agentskills.io)-compatible directories with a `SKILL.md` file.

The beauty of multi-agent is that skills follow the same isolation model:

- **Per-agent skills** live in `<workspace>/skills/` — only that agent sees them.
- **Shared skills** live in `~/.openclaw/skills/` — visible to all agents.
- **Bundled skills** ship with OpenClaw — available to everyone unless overridden.

So your coding agent might have specialized skills for GitHub PR reviews and deployment automation. Your social agent might have skills for scheduling posts and image generation. Your family agent might have smart home control skills. None of them leak into each other.

You can also install skills from [ClawHub](https://clawhub.com), the community skill registry:

```bash
# Install a skill into a specific agent's workspace
cd ~/.openclaw/workspace-coding
clawhub install github-pr-review

# Install a shared skill for all agents
cd ~/.openclaw/skills
clawhub install weather
```

## Step 6: Verify and Launch

```bash
# Verify bindings
openclaw agents list --bindings

# Check channel connectivity
openclaw channels status --probe

# Restart the Gateway
openclaw gateway restart
```

That's it. One Gateway process. Multiple isolated AI brains. Each with its own personality, memory, skills, model, and channel bindings.

## Why This Architecture Matters

Most competing frameworks treat multi-agent as "multiple LLM calls in a pipeline." CrewAI has agents that are really just prompt templates sharing a single execution context. LangGraph's agents are nodes in a graph — powerful for orchestration, but not for isolation. AutoGen's agents are conversation participants, not independent entities.

OpenClaw's agents are something different: **fully independent AI entities that happen to share a process**. Each one could theoretically run on its own server and behave identically. The Gateway is just the efficient way to host them together.

This design choice has real consequences:

**Security.** A compromised or jailbroken agent can't access another agent's data. Session stores are separate. Workspaces are separate. Auth profiles are separate. If someone tricks your public-facing customer bot into trying something malicious, it's sandboxed to that agent's scope.

**Cost optimization.** Your customer-facing agent that handles simple queries can run on a cheaper model (Sonnet, Gemini Flash). Your coding agent that needs to handle complex multi-file refactors can run on Opus. You're not paying Opus prices for every "what are your hours?" question.

**Memory integrity.** Each agent's `MEMORY.md` and daily memory files are its own. Your coding agent builds up context about your codebase over weeks. Your social agent learns your writing preferences. These memories don't interfere with each other, and they don't bloat each other's context windows.

**Personality consistency.** When an agent has a dedicated `SOUL.md`, it doesn't drift. A coding agent that's supposed to be terse doesn't suddenly start being chatty because the social agent's personality bled into the shared context. There is no shared context.

## Real-World Setup: What I Actually Run

For context, here's a simplified version of what runs on my server:

1. **Main agent** — personal assistant, connected to Discord and WhatsApp. Claude Opus. Has access to my calendar, email, smart home, and project files. Knows my preferences, my schedule, my work context.

2. **Blog publisher** — an isolated agent with cron jobs that automatically researches, writes, and deploys articles to multiple blogs. Runs on a schedule, doesn't need real-time chat.

3. **Home automation** — a lighter agent focused on smart home control. Connected to specific devices via paired iOS/Android/macOS nodes. Runs on a smaller model since its tasks are simpler.

Each one has its own workspace with tailored instructions, its own skills, and its own memory. The Gateway manages them all as a single process consuming minimal resources.

## The Bigger Picture

OpenClaw's multi-agent routing isn't just a feature — it's a statement about how AI assistants should work. The industry is obsessed with "one model to rule them all," shoving every possible use case into a single monolithic agent. That's how you get context windows bloated with irrelevant information, personalities that shift based on recent conversation topics, and security models that are one prompt injection away from catastrophe.

The alternative — which OpenClaw implements — is **specialization through isolation**. Multiple focused agents, each excellent at their job, each incapable of interfering with the others. It's the Unix philosophy applied to AI: do one thing well.

If you're running a single OpenClaw agent today and finding yourself wishing it could be more focused, or if you've been spinning up separate services for different use cases, multi-agent routing is worth the 20 minutes it takes to set up.

Get started at [docs.openclaw.ai](https://docs.openclaw.ai), browse the source at [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw), or join the community at [discord.com/invite/clawd](https://discord.com/invite/clawd).

*For more AI agent development tutorials and analysis, check out [commercialcoding.com](https://commercialcoding.com).*
