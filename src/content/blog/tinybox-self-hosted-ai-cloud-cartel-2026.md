---
title: "The $12,000 Tinybox Is Proof That the Cloud AI Cartel's Days Are Numbered"
description: "George Hotz's tinybox just hit the front page of Hacker News again — and this time, it's shipping. Here's why a petaflop in your closet changes everything about who controls AI."
pubDate: 2026-03-22
tags: ["ai", "self-hosted-ai", "tinybox", "tinygrad", "local-ai", "gpu", "deep-learning", "open-source", "ai-hardware"]
---

There's a computer sitting on a shelf at tinygrad.org right now that costs $12,000, fits in a closet, and delivers a petaflop of compute. It's called the **tinybox red v2**, it's in stock, and it ships within a week.

That sentence should terrify every cloud AI provider on the planet.

The tinybox — George Hotz's purpose-built deep learning workstation from tiny corp — just hit the front page of Hacker News for the umpteenth time. But unlike previous appearances where it was a preorder, a prototype, or a promise, this time it's a product. You can buy one right now. Red model with four AMD 9070 XT GPUs: $12,000. Green model with four RTX PRO 6000 Blackwell GPUs: $65,000. And for the truly ambitious, an exabox targeting one actual exaflop is coming in 2027 for around $10 million.

The HN thread has 281 comments and climbing. People are doing the math. And the math is devastating for cloud compute pricing.

**I'm going to argue that the tinybox isn't just a niche product for ML researchers. It's the opening shot in a war that will fundamentally restructure who has access to serious AI compute — and by extension, who gets to build the future.**

## The Cloud AI Tax Is Real, and Everyone Knows It

Let's do some napkin math.

A single NVIDIA A100 on AWS costs roughly $3.06 per hour on-demand. You need that GPU running 24/7 for a serious training run? That's $2,203 per month. For one GPU. A realistic multi-GPU training setup — say, 4x A100s — runs you $8,812 per month. Over a year, you're looking at **$105,744** just for compute.

The tinybox red v2 costs $12,000 once. Its four 9070 XT GPUs deliver 778 TFLOPS of FP16 compute with 64GB of total GPU RAM. Your electricity bill — even at European rates — adds maybe $200-300 per month at full load. After roughly two months of continuous use, you've broken even compared to cloud pricing. Everything after that is pure savings.

The green v2 is an even starker comparison. Four RTX PRO 6000 Blackwell GPUs with 384GB of GPU RAM and 3,086 TFLOPS. At $65,000, it sounds expensive — until you compare it to the cloud equivalent, which would cost you that much in about six months of continuous use.

This isn't a secret. Everyone in ML knows cloud compute is a terrible deal for sustained workloads. The cloud makes sense for burst compute — spin up 100 GPUs for a weekend, run your training job, tear it down. But for the growing number of teams, researchers, and indie developers who need persistent access to serious hardware, the cloud is a tax you pay for the privilege of not owning hardware.

The tinybox makes the alternative easy. And "easy" is the key word.

## Why This Matters More Than Previous "Build Your Own" Options

People have been building their own deep learning rigs for years. You can absolutely buy four consumer GPUs, stick them in a workstation motherboard, install Ubuntu, and start training. Some of the most interesting open-source AI work has happened on exactly this kind of hardware. So what makes the tinybox different?

**It's the whole stack, done right.**

When you build your own rig, you're dealing with PCIe lane allocation, power supply headroom, thermals, driver compatibility, fan curves, and the special joy of debugging why your fourth GPU randomly drops off the bus at 3 AM during a training run. You're running Ubuntu with whatever Frankenstein collection of CUDA drivers and Python environments you've accumulated over the years. When something breaks, you're on Stack Overflow at midnight.

The tinybox ships with Ubuntu, tinygrad, and PyTorch pre-installed. It has a BMC (baseboard management controller) for remote access. It was benchmarked on MLPerf Training 4.0 — the industry-standard ML benchmark — against machines that cost ten times as much. The power delivery is engineered for sustained GPU loads. The cooling is designed for a home or office (under 50 dB for the red model). The networking includes OCP 3.0 slots for future expandability.

More importantly, tiny corp's marketing copy includes a line that tells you everything about their philosophy: *"We don't have a stupid cloud service, you don't have to create a tiny account to set it up, and we aren't tracking how you use the box."*

That's not just a feature. That's a worldview.

## The Privacy Argument Nobody's Making Loudly Enough

Here's what keeps me up at night about the current AI landscape: **every serious AI workload runs through someone else's infrastructure**.

When you fine-tune a model on AWS, Amazon can see your training data. When you run inference through OpenAI's API, every prompt and response passes through their servers. When you use Google Cloud's TPUs, your model weights live on Google's machines. Yes, there are contracts and privacy policies. Yes, there are SOC 2 compliance certificates and data processing agreements. But the fundamental architecture is one of dependency and trust.

For a growing list of use cases, that's not good enough.

Healthcare organizations training models on patient data. Law firms fine-tuning on privileged client documents. Financial institutions building proprietary trading models. Defense contractors. Journalists protecting sources. Activists in countries with hostile governments. For all of these groups, "trust us, we won't look at your data" is an insufficient security model.

Self-hosted AI compute isn't just cheaper. It's the only architecture that provides actual data sovereignty. Your data never leaves your building. Your model weights never touch a third-party server. Your prompts never get logged in someone else's telemetry pipeline.

The tinybox makes this practical for organizations that aren't Google or Meta. A $12,000 investment gets you a machine that can fine-tune 7B-13B parameter models entirely on-premises. The $65,000 green box can handle 70B+ parameter models. These aren't toy capabilities — they're sufficient for most real-world enterprise AI applications.

If you're an AI consultant advising companies on their AI infrastructure strategy, and you're not presenting self-hosted as a serious option alongside cloud, you're doing your clients a disservice.

## The Open Source AI Stack Is Finally Good Enough

The hardware argument only works if the software is there. Two years ago, it wasn't. Today, it is.

**Inference:** Ollama has become the Docker of local AI. Install it, pull a model, start chatting. llama.cpp — the project that proved you could run large language models on consumer hardware — is now a mature, optimized runtime that supports dozens of model architectures. vLLM handles production-grade serving with batching and scheduling. LM Studio gives you a GUI if you want one.

**Training:** Hugging Face's transformers library supports LoRA and QLoRA fine-tuning on consumer GPUs. Axolotl wraps the complexity into config files. Unsloth claims 2x speedups on fine-tuning with less memory. The tinygrad framework itself — developed by tiny corp — is an alternative to PyTorch that's designed specifically for the kind of hardware in the tinybox.

**Agent frameworks:** This is where it gets really interesting. Open-source frameworks like [OpenClaw](https://github.com/openclaw/openclaw) let you run autonomous AI agents on your own hardware, with full control over what models they use and where your data goes. Instead of routing every agent action through a cloud API, you can point your agent at a local model served by Ollama or vLLM and keep everything in-house. The [OpenClaw documentation](https://docs.openclaw.ai) walks you through exactly this setup. Combined with a tinybox running local models, you get a fully self-contained AI agent stack that never phones home.

**Models:** Meta's Llama 3.x series is genuinely competitive with proprietary models for many tasks. Mistral's models are excellent for their size. DeepSeek pushed boundaries on reasoning. Qwen, Phi, Gemma — the open model ecosystem is rich and getting richer every month.

Two years ago, running AI locally meant accepting massive quality compromises. Today, a well-configured local setup with Llama 3.3 70B or Qwen 2.5 72B produces results that are 80-90% as good as the frontier proprietary models for most practical tasks. For fine-tuned domain-specific applications, local models often *exceed* proprietary ones because you can customize them for your exact use case.

The software stack was the missing piece. It's not missing anymore.

## Who This Is Actually For (And Who It Isn't)

Let me be clear-eyed about this. The tinybox is not for everyone, and pretending otherwise would be dishonest.

**The tinybox makes sense for:**

- ML researchers and PhD students who need sustained compute access without grant money disappearing into AWS bills
- AI startups in the pre-Series A phase who can't justify $10K/month in cloud compute
- Enterprise teams that need data sovereignty for compliance or competitive reasons
- AI consultancies and agencies that run multiple client workloads and want predictable costs
- Hobbyists and tinkerers who want to understand AI at the hardware level (the $12K red box is genuinely reasonable for a serious hobbyist)
- Anyone running [AI agent frameworks](https://commercialcoding.com) locally who needs the compute to back it up

**The tinybox doesn't make sense for:**

- Teams that need burst compute (100+ GPUs for a few days)
- Organizations training frontier-scale models (you need thousands of GPUs, not four)
- People who just want to run ChatGPT — use the API, it's fine
- Anyone without basic Linux system administration skills (you need to be comfortable with SSH and command lines)

The sweet spot is what I'd call the **"serious but not insane"** tier of AI compute. You need more than a single GPU in a gaming PC, but less than a data center. This is a surprisingly large and growing market — and it's exactly the market the cloud providers have been gouging.

## The Exabox and What Comes Next

The most interesting item on tinygrad.org isn't the red or green box. It's the **exabox**: a shipping container-sized system targeting one exaflop of compute with 720 AMD RDNA5 GPUs and 25,920 GB of GPU RAM. Expected in 2027 for approximately $10 million.

An exaflop for $10 million sounds like a lot until you realize that's roughly what it costs to rent equivalent cloud compute for 6-12 months. For a company that needs this level of compute on an ongoing basis — and there are more of these companies every month — buying an exabox is a no-brainer financially.

But the exabox represents something more than a product. It represents a thesis: **AI compute should be a capital expenditure, not an operating expense.** You should own your compute the way you own your office building. You should amortize it over years, not pay rent on it monthly.

This is how compute worked before the cloud era. Companies bought servers. They put them in closets, then in server rooms, then in co-location facilities. The cloud changed that model by offering convenience and elasticity. But for AI workloads — which tend to be sustained, predictable, and data-sensitive — the cloud model's advantages are rapidly eroding.

## What Cloud Providers Should Be Worried About

AWS, Google Cloud, and Azure aren't going to collapse overnight. They have massive advantages in managed services, global distribution, and elastic scaling. But they should be worried about the margin compression that's coming.

Right now, cloud GPU compute is priced with enormous margins because there's limited competition and high switching costs. But when a credible, shipping product offers equivalent compute at a fraction of the long-term cost, the pressure builds. Companies start doing the math. CFOs start asking questions. And once one team in an organization proves that self-hosted works, the conversation spreads.

The cloud providers' response will likely be aggressive pricing cuts on GPU instances — which is good for everyone. Competition drives prices down. Even if you never buy a tinybox, its existence makes your cloud bill cheaper.

## The Bigger Picture: Democratizing AI Isn't a Slogan

"Democratizing AI" has been a buzzword for years, mostly used by companies that want you to use *their* cloud platform to access AI. The actual democratization of AI requires two things: open models and accessible compute. We have the first. The tinybox — and the broader movement it represents — delivers the second.

When a graduate student in Nairobi or a startup in São Paulo or a researcher in Krakow can buy a machine that gives them the same training capabilities as a well-funded Silicon Valley startup, the geography of AI innovation changes. When a hospital can fine-tune a diagnostic model on their own patient data without it ever leaving their network, healthcare AI becomes possible in ways it wasn't before. When a journalist can run an AI agent on hardware they physically control, source protection becomes meaningful in the AI era.

This isn't abstract. This is happening. The tinybox is in stock. The models are open. The software stack works. The only question is whether you're still paying the cloud tax out of habit.

## My Take

The tinybox isn't perfect. You need to be comfortable with Linux. The AMD GPU ecosystem (red box) still lags behind NVIDIA in software maturity. Tinygrad, while promising, is not as battle-tested as PyTorch. And $12,000 is real money — it's not impulse-buy territory for most individuals.

But the direction is unmistakable. The cost of serious AI compute is falling. The software for running AI locally is maturing. The models are open and getting better. And companies like tiny corp are packaging all of this into products that actual humans can buy and use.

The cloud AI cartel — the handful of companies that control access to the compute required for serious AI work — has been operating without meaningful competition for years. The tinybox is a credible threat to that oligopoly. Not because it replaces the cloud entirely, but because it gives people a choice they didn't have before.

And in technology, choice is everything.

If you're building AI applications and you haven't seriously evaluated self-hosted compute, do the math. Check out [what's possible with local AI agent setups](https://commercialcoding.com). Look at the tinybox specs. Compare the three-year total cost of ownership against your cloud bill. The numbers might surprise you.

The era of AI compute as a utility you rent from three companies is ending. The era of AI compute as infrastructure you own is beginning. The tinybox is just the most visible symptom of a much larger shift.

*Own your compute. Own your data. Own your future.*
