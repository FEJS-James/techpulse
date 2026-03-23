---
title: "Perplexity Wants Your Health Data Now — And Apple Is Letting Them Have It"
description: "Perplexity Health integrates with Apple Health to answer medical questions using your biometrics. This is a privacy disaster in the making."
pubDate: "Mar 20 2026"
tags: ["AI", "Privacy", "Apple", "Health Tech", "Perplexity"]
---

Perplexity — the AI search company that got caught scraping publishers' content without permission, that was sued by Dow Jones and the New York Post, that had its crawlers exposed by both Wired and Cloudflare for spoofing user-agent strings to bypass website blocks — now wants access to your heart rate, sleep patterns, step counts, and medical data.

And Apple, the company that spent the last decade building its entire brand identity around the phrase "what happens on your iPhone stays on your iPhone," is letting them have it.

Welcome to Perplexity Health. It launched this week. AppleInsider's headline says "nobody should use it." They're right.

## What Perplexity Health Actually Does

Let's be precise about what we're talking about. Perplexity Health is a new feature within the Perplexity iOS app that integrates directly with Apple's HealthKit framework. Once you grant permission, it can access your Apple Health data — heart rate, sleep duration and quality, step counts, workout history, and potentially other biometrics your Apple Watch and iPhone have been silently collecting for years.

The pitch is simple: ask Perplexity a health question, and instead of getting a generic answer, it can reference *your* actual data. "Why am I sleeping poorly?" becomes a query that pulls your real sleep metrics. "Is my heart rate normal?" gets answered with your actual resting heart rate trends.

Sounds useful, right? That's the trap.

Because the question isn't whether personalized AI health answers *could* be valuable. Of course they could. The question is whether *this company*, with *this track record*, should be the one holding the keys to your most intimate biological data.

The answer is an unequivocal no.

## Perplexity's Trust Problem Isn't a Bug — It's a Pattern

Let's review the highlight reel, because it's genuinely remarkable how much trust-destroying behavior Perplexity has packed into just three and a half years of existence.

**June 2024:** Forbes publicly accused Perplexity of publishing stories "largely copied" from proprietary Forbes articles without proper citation. CEO Aravind Srinivas responded by calling it "rough edges" — the tech executive equivalent of "I'm sorry you feel that way." He maintained that Perplexity merely "aggregates" information, which is a creative way to describe taking someone else's journalism and repackaging it as your own.

**Also June 2024:** Dow Jones and the New York Post filed a copyright infringement lawsuit against Perplexity. The lawsuit didn't just allege content theft — it alleged that Perplexity's AI *hallucinated* quotes and attributed them to articles that never contained them. Think about that for a moment. The AI was making up quotes and stamping real news organizations' names on them.

**October 2024:** The New York Times sent a cease-and-desist notice to Perplexity for scraping and using NYT content without authorization.

**The Wired/Cloudflare exposé:** Independent analyses by Wired magazine and Cloudflare revealed that Perplexity was using undisclosed web crawlers with *spoofed user-agent strings* to scrape content from websites that explicitly blocked web scraping. This isn't a gray area. This is a company deliberately disguising its bots to circumvent access controls that website owners had put in place. In the physical world, we have a word for ignoring "No Entry" signs: trespassing.

This is the company that now wants to read your Apple Health data.

## The Privacy Calculus Is Insane

Health data is not like your search history. It's not like your browsing habits or your shopping preferences. Health data is in a category of its own, legally and ethically, because of what it reveals about you and because of how it can be used against you.

Your resting heart rate trends can indicate cardiovascular conditions. Your sleep patterns can suggest mental health issues. Your activity data can reveal mobility problems. Taken together, these data points paint an extraordinarily detailed picture of your physical and psychological state — a picture that would be enormously valuable to insurance companies, employers, data brokers, and advertisers.

Now consider Perplexity's business model. The company reached a $21.21 billion valuation as of early 2026. Its Annual Recurring Revenue grew from $80 million in late 2024 to an estimated $200 million by February 2026. It processes around 30 million queries daily. It recently dropped its advertising strategy in favor of a subscription-first model.

Here's the thing about subscription-first models at a $21 billion valuation: they have to grow. Fast. And when growth slows — and it always slows — the pressure to monetize the data you've been collecting becomes overwhelming. We've seen this movie before. The data you gave a company voluntarily when it was promising to be different becomes the data it sells, shares, or "partners" around when the quarterly numbers need to look better.

Perplexity has Jeff Bezos as an investor. And Nvidia. And it recently committed $750 million to Microsoft Azure for GPU capacity. These numbers don't get paid back with $20/month Pro subscriptions alone. The pressure to find additional revenue streams from the data sitting in their systems is not a hypothetical — it's an economic inevitability.

## Apple's HealthKit Hypocrisy

But let's not let Apple off the hook here. This is, arguably, the more infuriating half of the story.

Apple has marketed itself as the privacy company for the better part of a decade. "Privacy. That's iPhone." was plastered on billboards the size of buildings. Tim Cook has personally positioned himself as the anti-Zuckerberg, the CEO who believes privacy is a "fundamental human right." Apple's entire HealthKit framework was designed — we were told — with privacy as the core principle. Health data stays on your device. It's encrypted. You control who sees it.

Except... you can also just hand it all to Perplexity with a single permission toggle.

Apple's HealthKit does require user consent before sharing data with third-party apps. That's true. But "user consent" in the age of AI is a fig leaf the size of a postage stamp. Most people don't read permission dialogs. Most people don't understand the implications of granting a data-hungry AI company access to their biometrics. And most people trust that if an app is available in the App Store, and it integrates with Apple's own frameworks, then Apple has vetted it and deemed it safe.

Apple's App Store review process is supposed to catch bad actors. Apple takes a 30% cut of app revenue specifically because, in theory, it provides a curated, safe ecosystem. So where was the curation here? Where was the due diligence on a company with an *active pattern* of ignoring data boundaries?

The answer, presumably, is that Perplexity technically complies with HealthKit's data use guidelines. It asks permission. It probably stores data appropriately, on paper. But technical compliance and trustworthiness are not the same thing. A company that has repeatedly demonstrated it will take data it wasn't supposed to take, use content it wasn't licensed to use, and disguise its crawlers to bypass explicit blocks — that company *technically complying* with your health data guidelines should not inspire confidence. It should trigger alarm bells.

Apple chose to let this through. That's a choice. And it undermines every privacy billboard they've ever put up.

## The Medical Misinformation Risk Is Real

Set aside the privacy concerns for a moment — though you shouldn't — and consider the medical accuracy problem.

Perplexity Health is not a medical device. It's not FDA-regulated. It's not staffed by doctors. It's a large language model that has been pointed at your health data and told to say helpful things. And we know, from extensive documentation, that large language models hallucinate. They make things up. They present fabricated information with the same confident, authoritative tone as real information.

Remember: Perplexity's AI was caught attributing *made-up quotes* to real news organizations. That was about journalism. Now apply that same hallucination tendency to your health data.

Imagine asking Perplexity Health "Is my heart rate pattern concerning?" and getting a confidently wrong answer. Imagine it telling you a pattern is normal when it isn't, or telling you something is alarming when it's perfectly fine. Imagine the anxiety of a health-anxious person who now has an AI "doctor" in their pocket that sounds authoritative but is fundamentally guessing.

The disclaimers will be there, buried in the fine print. "This is not medical advice." "Consult your doctor." But if the product weren't designed to be *acted upon*, it wouldn't exist. Perplexity isn't building this feature so you can ignore it. They're building it so you'll use it. And when people use AI health tools, [research consistently shows](https://commercialcoding.com) they tend to trust the output more than they should.

This isn't a theoretical risk. It's the entire business model.

## The Trust Stack Is Broken

What makes the Perplexity Health situation so telling is that it exposes a broken trust stack in the entire AI ecosystem.

At the bottom, you have Apple — the hardware company that collects your health data through devices you've bought and paid for. Apple promises this data is private and secure. Then Apple opens a HealthKit API that lets third-party developers access that data with user consent.

In the middle, you have Perplexity — a company valued at over $21 billion, backed by some of the richest people and companies on Earth, with a documented history of taking data it shouldn't. Perplexity gets access to your health data through Apple's API and promises to use it responsibly.

At the top, you have the user — who just wants to know why they've been sleeping badly, and who assumes that if Apple and Perplexity are working together, everything must be above board.

Every layer of this stack is operating on assumptions about the layer below it. The user trusts Apple. Apple trusts (or at least tolerates) Perplexity. Perplexity trusts... well, Perplexity trusts that you won't think too hard about any of this.

We've written before about how [AI agent frameworks are changing what software can do](/blog/openclaw-ai-agent-revolution/) — giving AI models real tools and real access to your digital life. The potential is enormous. But potential cuts both ways. When the framework is [built with security as a core principle](/blog/nvidia-nemoclaw-openclaw-enterprise-security-gtc-2026/), AI agents can be genuinely transformative. When it's built by a company whose core competency appears to be taking things it wasn't given permission to take, you get Perplexity Health.

The difference between a useful AI health tool and a privacy nightmare isn't the technology. It's the company behind it. It's the governance. It's the track record.

## What HIPAA Doesn't Cover

Here's a detail that should make everyone uncomfortable: consumer health data collected through apps like Perplexity Health likely isn't covered by HIPAA.

The Health Insurance Portability and Accountability Act — the law most Americans assume protects all their health information — only applies to "covered entities" like hospitals, insurance companies, and healthcare providers. A consumer AI app that reads your Apple Health data? That's almost certainly not a covered entity.

This means Perplexity's handling of your health data is governed primarily by its own privacy policy and the terms of Apple's HealthKit framework. Not by federal health privacy law. Your heart rate data, sleep patterns, and activity metrics are sitting in a legal gray zone where the protections most people assume exist simply don't.

Some states have begun passing consumer health data privacy laws — Washington's My Health My Data Act is the most notable example. But enforcement is inconsistent, and the laws are still catching up to a world where AI companies can hoover up biometric data through smartphone integrations.

If you're thinking "surely the government will step in if something goes wrong" — look at how well that's worked for every other tech privacy scandal in the last decade and adjust your expectations accordingly.

## The Bigger Pattern: Move Fast and Break Trust

Perplexity Health isn't an isolated incident. It's the latest expression of a pattern that has defined the AI industry since the ChatGPT explosion: build fast, grab data, figure out the ethics later, and hope the regulators are too slow to catch up.

We saw it with [BuzzFeed's catastrophic AI pivot](/blog/buzzfeed-ai-bankruptcy-lesson-2026/) — a company that thought AI could replace human judgment and paid the price. We're seeing it with every AI startup that treats user data as a resource to be extracted rather than a responsibility to be honored.

Perplexity has raised billions of dollars. It has some of the most sophisticated investors in Silicon Valley. It has access to the best legal advice money can buy. And yet, repeatedly, it has chosen the path that prioritizes data acquisition over data ethics. Spoofing crawlers. Scraping blocked sites. Repackaging others' journalism.

And now: "Hey, can we also have your heart rate?"

The audacity would be impressive if it weren't so dangerous.

## What You Should Actually Do

If you've already granted Perplexity access to your Apple Health data, revoke it. Go to Settings → Health → Data Access & Devices → Perplexity, and turn it off. Right now. Before you finish reading this article.

If you haven't granted access, don't. No matter how slick the demo looks. No matter how useful personalized health answers sound. The risk-reward calculus here is wildly unfavorable. You're handing your most intimate biological data to a company that has repeatedly demonstrated it doesn't respect data boundaries — in exchange for an AI health assistant that isn't medically regulated, can hallucinate, and exists primarily to grow Perplexity's user engagement metrics.

If you want AI-powered health insights, wait for a company that has actually earned your trust to build them. Or better yet, talk to your doctor. They went to medical school. The large language model didn't.

## The Line We Shouldn't Cross

There's a version of AI health tools that could be genuinely revolutionary. Imagine an open-source, locally-run model that analyzes your health data without it ever leaving your device. No corporate servers. No investor pressure to monetize. No history of content theft. Just a tool that helps you understand your body, with full transparency about its limitations.

That's not what Perplexity Health is. Perplexity Health is a venture-backed, data-hungry company with a $21 billion valuation and a track record of ignoring "no" — reaching into the most private data your phone collects about you.

Apple should never have let this happen. The App Store review process exists precisely for moments like this. A company with Perplexity's documented history of data boundary violations should have been flagged, questioned, and required to demonstrate — not just claim — that it would handle health data differently than it handles everything else.

Instead, Apple waved it through. And now millions of users are one permission toggle away from handing their biometrics to the company that spoofed its web crawlers to steal journalism.

Privacy isn't just a billboard slogan. It's not a feature you can toggle on and off depending on whether the partnership makes business sense. It's either a principle or it isn't.

Right now, for both Apple and Perplexity, it pretty clearly isn't.
