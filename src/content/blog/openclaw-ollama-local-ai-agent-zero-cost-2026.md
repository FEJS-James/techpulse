---
title: "How to Run a Fully Local AI Agent With OpenClaw and Ollama"
description: "Build an openclaw ollama local ai agent with zero API costs. Full tutorial: tool calling, file management, and Discord — all running on your machine."
pubDate: "2026-03-23"
author: "Alex Chen"
heroImage: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80"
tags: ["AI", "OpenClaw", "Ollama", "Local AI", "Tutorial", "Self-Hosted"]
---

Someone just ran a 397-billion-parameter AI model on a MacBook and got it to call tools at 4.4 tokens per second. That's not a benchmark flex — it's the moment local models became real agent backends. And yet most developers are still burning $50–200/month on API calls for tasks a Qwen 3.5 27B handles without breaking a sweat. This guide shows you how to build a fully functional **openclaw ollama local ai agent** that can execute shell commands, manage files, browse the web, and respond on Discord or WhatsApp — with zero tokens leaving your machine and zero dollars leaving your wallet.

The cloud AI tax is optional now. Here's how to stop paying it.

## The Local Model Tipping Point

Let's talk about what just happened. Flash-MoE — a mixture-of-experts architecture with 397 billion parameters — ran on a MacBook Pro with 192GB of unified memory. Not a datacenter. Not an 8×H100 cluster. A laptop. It produced coherent tool-calling output at 4.4 tokens per second. That's slow by cloud standards, but it's fast enough to be *useful*, which is the only metric that matters.

But Flash-MoE isn't even the story. It's the exclamation point on a trend that's been building all year. Look at what's sitting in the [Ollama model library](https://ollama.com/library) right now:

- **Qwen 3.5 27B** — Alibaba's open-weight beast that nails structured output and tool calling at a size that fits in 20GB of RAM with 4-bit quantization.
- **Llama 3.3 70B** — Meta's workhorse. Needs 48GB+ of RAM but delivers reasoning quality that embarrassed GPT-4 in early 2025.
- **GLM-4.7-Flash** — Zhipu's speed demon. Smaller, faster, surprisingly competent at agentic tasks.

A year ago, running any of these locally meant fighting with GGUF conversions, writing custom inference scripts, and praying your tool-calling prompts didn't hallucinate malformed JSON. In 2026, you pull a model with one command and point an agent framework at it.

The inference layer is solved. The question was always: what do you *do* with a local model once it's running?

## Why Local Models + Agent Frameworks Are the Killer Combo

Here's the dirty secret about local LLMs: by themselves, they're chatbots. Expensive, power-hungry chatbots that live on your machine instead of someone else's. You can ask them questions. They answer. That's it.

An agent framework turns that chatbot into something that actually *does things*. Shell commands. File creation and editing. Web searches. API calls. Database queries. Calendar management. The model becomes the brain; the framework becomes the body.

This is where [OpenClaw](https://docs.openclaw.ai) enters the picture — and why I think it's currently the best option for local-first agent setups. Unlike frameworks that bolt on local model support as an afterthought, OpenClaw treats Ollama, vLLM, and SGLang as first-class inference backends. You're not fighting compatibility layers or translating between API formats. You point it at your local endpoint and it works.

If you haven't used OpenClaw before, [our getting started guide](/blog/openclaw-ai-agent-revolution) covers the basics. But the short version: it's an agent runtime that gives your LLM access to tools — file operations, shell execution, web browsing, message channels (Discord, WhatsApp, Telegram), device control, and more. It handles conversation memory, multi-model routing, and the entire tool-calling loop so you don't have to.

The combination of a capable local model + a full agent framework is the actual unlock. Not faster inference. Not bigger models. The ability to take a model running on your hardware and give it real agency over real tasks.

## Step-by-Step — Setting Up Your OpenClaw Ollama Local AI Agent

Enough philosophy. Let's build this thing.

### 1. Install Ollama

If you don't have Ollama yet:

```bash
# macOS / Linux
curl -fsSL https://ollama.com/install.sh | sh

# Or on macOS with Homebrew
brew install ollama
```

Start the Ollama server:

```bash
ollama serve
```

This runs on `localhost:11434` by default. Leave it running.

### 2. Pull a Model With Tool-Calling Support

Not every model handles tool calling well. Start with Qwen 3.5 27B — it's the current sweet spot for local agent work:

```bash
ollama pull qwen3.5:27b
```

This downloads the 4-bit quantized version (~18GB). If you have 64GB+ of RAM and want better quality:

```bash
ollama pull qwen3.5:27b-fp16
```

Verify it's working:

```bash
ollama run qwen3.5:27b "What is 2+2?"
```

If you get an answer, your inference layer is ready.

### 3. Install and Onboard OpenClaw

```bash
npm install -g openclaw
openclaw onboard
```

The onboard wizard walks you through initial setup. When it asks about your model provider, select **Ollama** or choose **Custom/OpenAI-compatible** and point it at your local endpoint.

### 4. Configure the Local Model

Here's where most tutorials fail you. Ollama exposes an OpenAI-compatible API at `/v1`, but you need to specify the full URL. Open your OpenClaw configuration:

```bash
openclaw config
```

Set your default model to the local Ollama instance:

```yaml
defaults:
  model: ollama/qwen3.5:27b
  baseURL: http://localhost:11434/v1
```

**The `/v1` gotcha:** Ollama's native API lives at `localhost:11434/api`. The OpenAI-compatible endpoint — the one OpenClaw needs — is at `localhost:11434/v1`. Miss that `/v1` and you'll get cryptic connection errors. Ask me how I know.

### 5. Verify Tool Calling

Fire up OpenClaw and test that your local model can actually use tools:

```bash
openclaw chat
```

Try something that requires a tool call:

```
> What files are in my home directory?
```

If the model lists your actual files (not hallucinated ones), congratulations — you have a fully local AI agent. No API key. No cloud endpoint. No data leaving your machine.

```
> Create a file called test.txt with "Hello from local AI" in it
```

Check that the file exists. If it does, your local agent is operational. Every tool call, every file operation, every web search — all running through your local model.

### 6. Connect to Discord or WhatsApp (Optional)

This is where it gets fun. You can connect your local agent to messaging platforms:

```bash
openclaw connect discord
```

Now your locally-running AI agent responds to Discord messages. Someone pings your bot, the message routes to your local Qwen 3.5, the model decides what tools to use, executes them, and responds — all without a single API call to Anthropic, OpenAI, or anyone else.

## Which Local Models Actually Work for Tool Calling

Not all models are created equal when it comes to agentic tasks. Tool calling requires the model to output structured JSON reliably, follow multi-step reasoning, and know when *not* to call a tool. Here's my honest ranking after months of testing:

### Tier 1: Production-Ready

**Qwen 3.5 27B (Q4_K_M quantization)**
- RAM: ~20GB
- Speed: 8–15 tok/s on Apple Silicon (M2 Pro and up)
- Tool calling: Excellent. Reliable JSON output, handles multi-tool chains, rarely hallucinates tool names.
- Verdict: The default choice. If you're only going to run one local model, make it this one.

**Llama 3.3 70B (Q4_K_M quantization)**
- RAM: ~48GB
- Speed: 3–6 tok/s on 64GB machines
- Tool calling: Very good. Stronger reasoning than Qwen 3.5 on complex tasks, but the speed penalty is real.
- Verdict: Use it if you have the RAM and patience. Noticeably smarter on multi-step plans.

### Tier 2: Fast and Capable

**GLM-4.7-Flash**
- RAM: ~8GB
- Speed: 20–30 tok/s on Apple Silicon
- Tool calling: Good for simple tasks. Struggles with 4+ tool chains.
- Verdict: Great for quick, single-tool tasks. Snappy response times make it feel like a cloud model.

**Qwen 3.5 14B**
- RAM: ~10GB
- Speed: 15–25 tok/s
- Tool calling: Decent. Occasional JSON formatting issues under complex scenarios.
- Verdict: The budget option. Works for 80% of agent tasks on machines with limited RAM.

### Tier 3: Experimental

**Flash-MoE 397B**
- RAM: 192GB (yes, really)
- Speed: 4.4 tok/s
- Tool calling: Promising but slow. The MoE architecture means quality is high when it works.
- Verdict: A proof of concept, not a daily driver. But it proves the ceiling is rising fast.

### The Quantization Floor

Here's a rule of thumb: **4-bit quantization (Q4_K_M) is the floor for reliable tool calling.** Go below that and you'll see JSON formatting errors, hallucinated tool parameters, and incomplete function calls. The model needs enough precision to handle structured output without falling apart.

If you can afford it, 5-bit or 6-bit quantization meaningfully improves tool-calling reliability. The extra 4–8GB of RAM is worth it.

## Advanced — vLLM and SGLang for Power Users

Ollama is great for single-user local setups. But if you're running multiple agents, serving a team, or have a dedicated GPU server, you want a proper inference engine.

### vLLM Setup

```bash
pip install vllm
vllm serve qwen/Qwen3.5-27B-AWQ --port 8000
```

Point OpenClaw at it:

```yaml
defaults:
  model: qwen3.5-27b
  baseURL: http://localhost:8000/v1
```

vLLM gives you continuous batching, PagedAttention for efficient memory use, and significantly better throughput than Ollama for concurrent requests. If you're running this on a machine with a dedicated NVIDIA GPU (or multiple), vLLM is the move.

### SGLang Setup

```bash
pip install sglang
python -m sglang.launch_server --model qwen/Qwen3.5-27B-AWQ --port 8000
```

Same OpenClaw configuration — SGLang exposes an OpenAI-compatible API by default. SGLang tends to edge out vLLM on throughput for tool-calling workloads because of its RadixAttention prefix caching, which is particularly useful when you're making repeated similar tool calls.

### Multi-GPU with OpenClaw

If you're running a [self-hosted GPU setup like a tinybox](/blog/tinybox-self-hosted-ai-cloud-cartel-2026), both vLLM and SGLang handle tensor parallelism across multiple GPUs automatically:

```bash
vllm serve qwen/Qwen3.5-27B --tensor-parallel-size 2 --port 8000
```

OpenClaw doesn't care what's behind the endpoint. Ollama on a MacBook, vLLM on a 4×A100 cluster, SGLang on a tinybox — it's all the same `/v1` API. This is the beauty of standardized interfaces.

## The Real Cost Comparison

Let's do the math that API providers don't want you to do.

**Claude Opus 4 pricing (March 2026):**
- Input: $15 per million tokens
- Output: $75 per million tokens

**A typical agent session:**
- ~2,000 input tokens (system prompt + user message + tool results)
- ~800 output tokens (reasoning + tool calls + response)
- Average cost per session: ~$0.09

**50 sessions per day (a modest workload for a personal agent):**
- Daily cost: $4.50
- Monthly cost: **$135/month**

**Local Ollama setup:**
- Hardware: MacBook you already own (or a $600 used Mac Mini with 32GB)
- Electricity: ~$3–5/month for the extra GPU load
- API costs: **$0/month**

That's $135 vs $5. Per month. Every month. Forever.

And that's with *one* cloud model. If you're using GPT-4.1 for some tasks and Claude for others — which is common with [multi-model routing setups](/blog/openclaw-multi-agent-routing-tutorial-2026) — your cloud bill climbs higher. The local model sits there, burning electricity and nothing else.

Over a year, the cloud agent costs $1,620. The local agent costs $60 in electricity. You're paying $1,560 per year for the privilege of sending your data to someone else's computer.

## What Local Models Still Can't Do

I'd be lying if I told you to cancel your Anthropic subscription today. Local models have crossed the "good enough" threshold, but "good enough" has boundaries.

**Where 27B models fall short:**

- **Complex multi-file code generation.** Ask a local Qwen 3.5 to refactor a 500-line TypeScript module and it'll give you a decent attempt. Ask Claude Opus to do it and it'll give you production-ready code with edge cases handled. The gap is real.
- **Long context reasoning.** Most local models tap out around 32K–128K context. Opus handles 200K. If your agent needs to reason over an entire codebase, local models choke.
- **Nuanced instruction following.** Local models are more likely to ignore subtle constraints in complex prompts. They'll do the task, but miss the finer points.
- **Novel problem-solving.** For tasks that require genuine creativity or reasoning about unfamiliar domains, larger cloud models still have an edge.

**The honest recommendation: go hybrid.**

OpenClaw supports multi-model routing, which means you can send 80% of your tasks to the local model and route the hard stuff to a cloud API. File management? Local. Discord responses? Local. Complex coding task? Route to Opus.

This is the setup I actually use. Check our [multi-model routing tutorial](/blog/openclaw-multi-agent-routing-tutorial-2026) for the full walkthrough — but the short version is you define routing rules in your OpenClaw config, and the framework picks the right model for each task automatically.

```yaml
models:
  default: ollama/qwen3.5:27b
  coding: anthropic/claude-opus-4
  routing:
    - match: "write code|refactor|debug"
      model: coding
    - match: "*"
      model: default
```

Now you get the best of both worlds: $0 for the bulk of your workload, and cloud quality when it matters.

## The Bottom Line

Local AI agents aren't a compromise anymore — they're a deliberate choice. A choice for privacy, since zero tokens leave your machine. A choice for cost, since you stop paying the cloud tax. And increasingly, a choice for quality, since models like Qwen 3.5 27B handle the vast majority of agentic tasks without embarrassing themselves.

The [agent framework wars](/blog/ai-agent-framework-war-openclaw-wins-2026) are settling down, and the winners are the ones that treat local inference as a first-class citizen. OpenClaw's native Ollama support means you're not fighting compatibility layers — you're just building.

The setup takes 15 minutes. The monthly savings start immediately. And the next time someone tells you that you *need* a cloud API for a real AI agent, you can show them the one running on your laptop that just managed their files, searched the web, and responded on Discord — without sending a single byte to anyone's server.

Your tokens. Your hardware. Your agent.

Install Ollama. Pull Qwen 3.5. Run `openclaw onboard`. Welcome to the post-cloud era.
