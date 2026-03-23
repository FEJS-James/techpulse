---
title: "Nvidia GreenBoost Lets You Fake More VRAM — And It Actually Kind of Works"
description: "An open-source CUDA shim tricks your GPU into using system RAM as VRAM. It's janky, it's clever, and it exposes everything wrong with NVIDIA's memory strategy."
pubDate: "Mar 19 2026"
tags: ["GPU", "NVIDIA", "Open Source", "PC Hardware", "AI"]
---

There's a project sitting at the top of Hacker News right now with 277 points and climbing. It's called [Nvidia GreenBoost](https://gitlab.com/IsolatedOctopi/nvidia_greenboost), and it does something NVIDIA would really rather you not think about: it transparently extends your GPU's VRAM by borrowing system RAM and NVMe storage.

Read that again. A lone developer on GitLab built a CUDA shim — a thin layer that sits between your applications and the GPU driver — that makes your system RAM appear as additional VRAM. Your 8GB RTX 4060? GreenBoost can make it pretend it has 32GB. Your 12GB RTX 4070? Now it thinks it's got 64GB.

And here's the part that's making people lose their minds: **it actually kind of works.**

## How It Works (And Why It Shouldn't Be This Easy)

GreenBoost operates as a CUDA interposer — essentially a man-in-the-middle between your CUDA applications and NVIDIA's driver stack. When a program requests GPU memory allocation, GreenBoost intercepts the call. If there's real VRAM available, it allocates there as normal. When VRAM runs out, it transparently redirects the overflow to system RAM, and optionally to NVMe-backed swap.

The application never knows the difference. As far as your AI inference engine or 3D renderer is concerned, the GPU has as much memory as you've configured GreenBoost to expose.

This is not a new concept. Virtual memory has been doing this for CPUs since the 1960s. What's remarkable is that NVIDIA hasn't done it themselves. The hardware supports PCIe-based memory access. The driver *could* implement transparent VRAM extension. NVIDIA simply... chose not to.

The cynical read is obvious: if your 8GB card could seamlessly use 32GB of system RAM as overflow, why would you buy a card with more VRAM? NVIDIA's entire product segmentation — from the [RTX 5090's 32GB](/blog/nvidia-rtx-5090-review-2026/) down to budget cards with 8GB — depends on VRAM being a hard wall. GreenBoost just punched a hole in that wall.

## The Performance Reality Check

Let's not pretend this is magic. System RAM is fundamentally slower than VRAM. A modern GPU like the RTX 4090 has about 1 TB/s of memory bandwidth to its onboard GDDR6X. Your DDR5 system RAM? Maybe 50-80 GB/s. PCIe 5.0 x16 tops out around 64 GB/s. That's an order of magnitude slower.

So when GreenBoost spills data to system RAM, anything that touches that data takes a massive hit. The Hacker News thread is full of people sharing numbers, and they paint an honest picture:

**The baseline (Ollama, pure system RAM overflow):** 2-5 tokens per second. Usable for testing. Painful for actual work.

**The optimized path (ExLlamaV3 + GreenBoost cache):** 8-20 tokens per second. Now we're talking.

That spread tells you everything about where GreenBoost actually shines. The raw approach — just dumping overflow to system RAM and hoping for the best — is predictably slow. But when combined with an inference engine that understands memory tiers and can keep hot data in real VRAM while parking cold weights in system RAM, performance gets genuinely interesting.

The key insight is this: most large language models don't access all their parameters equally. During inference, attention layers get hammered constantly, but many weight matrices are accessed infrequently. If you can keep the hot path in real VRAM and let the cold overflow sit in system RAM, the performance penalty only materializes on the rare cache misses. For a model that *almost* fits in your GPU's VRAM — say, a 14B parameter model on a 12GB card — GreenBoost might only need to park 2-3GB in system RAM. If those 2-3GB are rarely-accessed weights, you might barely notice the difference.

**That "almost fits" scenario is GreenBoost's killer use case.** And it's a surprisingly common one. The AI community is full of people running models that are just barely too large for their hardware — quantizing down one more step, splitting across GPUs, or offloading layers manually. GreenBoost automates the overflow, and when the overflow is small relative to total VRAM, it works well.

## For Gaming? Not So Much

If you're hoping GreenBoost will let you crank texture quality beyond your VRAM limit, temper your expectations. Gaming workloads are fundamentally different from AI inference. Games access textures in unpredictable, spatially-dependent patterns. A frame might need any texture from any part of the game world at any moment. There's no "hot path" to keep in VRAM — everything is potentially hot.

The result is constant thrashing between VRAM and system RAM, and the latency kills frame times. Even if average FPS looks okay, the frame-time spikes create nauseating stuttering. The HN commenters who tried it for gaming universally reported the same thing: it loads, it runs, and it feels terrible.

This isn't GreenBoost's fault. It's a fundamental limitation of the bandwidth gap between VRAM and system RAM. Until we get architectures where system memory and GPU memory share the same bandwidth (looking at you, Apple Silicon), transparent VRAM extension for gaming workloads will remain impractical.

## AMD Already Does This. With a Kernel Parameter.

Here's the part that should make NVIDIA shareholders nervous.

On AMD GPUs, you can already extend VRAM into system RAM. It's a kernel parameter: `amdttm.pages_limit`. Set it, reboot, and your AMD GPU will transparently use system RAM as overflow memory. It's been there for a while. It's not hidden. AMD just... lets you do it.

The performance characteristics are similar to GreenBoost — system RAM is still slower than GDDR6, physics hasn't changed — but the fact that AMD baked it into their driver stack tells you something about corporate philosophy. AMD sees VRAM extension as a feature. NVIDIA sees it as a threat to their upsell strategy.

This is the same company that [told gamers they were wrong about needing more VRAM](/blog/jensen-huang-gamers-wrong-dlss-5-nvidia-2026/) because DLSS would handle everything. Jensen Huang has spent years arguing that AI upscaling eliminates the need for raw memory and raw resolution. GreenBoost is the community saying: "We'll decide what we need, thanks."

## The Community Divide

The Hacker News discussion is a microcosm of the broader GPU community's frustration with NVIDIA.

**The skeptics** argue that GreenBoost is a solution in search of a problem. Manual layer offloading — explicitly telling your inference engine which model layers to put on CPU vs GPU — gives you more control and often better performance. Why use a transparent shim when you can be surgical about memory placement? They're not wrong. If you know what you're doing, manual offloading is superior. The keywords there being "if you know what you're doing."

**The supporters** see bigger potential. GreenBoost today is version 0.x — a proof of concept. But the architecture enables things that manual offloading can't:

- **Predictive loading:** Pre-fetching weights from system RAM to VRAM before they're needed, hiding the latency entirely
- **Hybrid compute scheduling:** Automatically deciding which operations run on GPU vs CPU based on where their data lives
- **Dynamic tier management:** Promoting frequently-accessed data to VRAM and demoting cold data, continuously optimizing placement

None of this exists yet. But the shim architecture makes it possible. That's what has the "this is actually interesting" crowd excited — not what GreenBoost does today, but what it could enable tomorrow.

**The pragmatists** (where I land) say both sides are half right. GreenBoost won't replace a GPU with more VRAM. It won't make your RTX 4060 into a 4090. But for the very specific use case of "my model is 2GB too big for my GPU," it's a legitimate tool that saves you from either buying a new card or degrading your model with more aggressive quantization.

## The Real Story: Open Source Filling NVIDIA's Gaps

Here's what bothers me about the whole thing.

GreenBoost is a CUDA shim written by one person. It intercepts memory allocation calls and redirects them. It's not touching the hardware. It's not exploiting a vulnerability. It's using documented (if underpublicized) PCIe memory access mechanisms that NVIDIA's own hardware fully supports.

NVIDIA could ship this as a driver feature tomorrow. They could call it "NVIDIA VRAM Boost" or "GeForce Memory Extension" or whatever marketing name their branding team comes up with. They could integrate it with their driver's memory manager, add smart caching, build in the predictive loading that the community is dreaming about. They have the engineers. They have the telemetry data about access patterns. They have the driver-level access that a userspace shim will never have.

They won't do it. Because NVIDIA's business model depends on VRAM being a hard constraint that pushes consumers up the product stack.

This is the same pattern we've seen over and over. NVIDIA ships hardware with artificial limitations. The community routes around them. NVIDIA eventually adopts the feature in a future generation and charges a premium for it.

Remember when NVIDIA locked out resizable BAR on older GPUs even though the hardware supported it? Remember when they artificially limited crypto mining on certain cards? Remember when ECC memory was a "Quadro only" feature despite GeForce hardware being perfectly capable?

The playbook is always the same: segment the market, lock features behind price tiers, and let the enthusiast community do the R&D for free.

## Should You Use GreenBoost?

If you're running local AI inference and your model is slightly too large for your VRAM, yes. Absolutely. The setup is straightforward — clone the repo, build the shim, set your environment variables, and launch your inference engine. The GitLab repo has clear documentation.

Pair it with ExLlamaV3 for best results. The combination of GreenBoost's transparent memory extension and ExLlamaV3's cache-aware inference engine gets you into genuinely usable territory for models that would otherwise require a more expensive GPU.

If you're gaming, skip it. The bandwidth gap between VRAM and system RAM makes real-time rendering workloads impractical. Wait for unified memory architectures to mature.

If you're on AMD, just use `amdttm.pages_limit`. You don't need a third-party shim.

## The Bigger Picture

GreenBoost matters not because of what it is — a clever memory trick — but because of what it represents. The GPU computing community is tired of artificial limitations. They're tired of being told that 8GB of VRAM is "enough" by a company that charges $2000 for 32GB. They're tired of segmentation strategies that leave performance on the table to protect profit margins.

Open source keeps doing this. It keeps finding the gaps between what hardware *can* do and what vendors *let* it do, and it keeps filling those gaps with code. Sometimes the solutions are elegant. Sometimes they're duct tape and prayer. GreenBoost is somewhere in between — clever enough to work, rough enough to remind you it shouldn't have been necessary.

NVIDIA won't acknowledge GreenBoost. They certainly won't ship a competing feature. But somewhere in Santa Clara, a driver engineer is looking at this project and thinking: "Yeah, we could have done that."

They could have. They chose not to. And so an open-source developer on GitLab did it for them.

That tells you everything you need to know about where NVIDIA's priorities actually are — and it's not with the people buying their GPUs.
