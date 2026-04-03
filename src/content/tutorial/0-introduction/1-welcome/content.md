---
type: lesson
title: Welcome
editor: false
terminal: false
previews: false
---

# Welcome to Getting Started with RubyLLM

RubyLLM is a Ruby gem that gives you a **single, elegant interface** to work with multiple AI providers — OpenAI, Anthropic, Google Gemini, and more. Instead of learning a different SDK for each provider, you write Ruby. One API, any model.

This tutorial runs entirely in your browser — no installation, no API keys required to follow along. The Ruby runtime is built into the page.

:::tip
For the best experience, use a modern browser (Chrome, Firefox, or Edge). Safari works but may be slower to start.
:::

## What You'll Learn

By the end of this tutorial, you'll be able to:

- **Configure RubyLLM** and connect it to multiple AI providers
- **Explore the model registry** to discover and compare available models
- **Build multi-turn conversations** with persistent context
- **Stream responses** in real time as the model generates them
- **Send files and images** alongside messages with multi-modal input
- **Generate embeddings** and work with vector representations of text
- **Generate images** from text prompts with DALL-E and Imagen
- **Transcribe audio** to text with Whisper and GPT-4o Transcribe
- **Create AI tools** using plain Ruby classes — no JSON schema boilerplate
- **Build agents** that reason, plan, and call tools autonomously
- **Extract structured data** from unstructured text using typed outputs
- **Compose agentic workflows** — sequential pipelines and evaluation loops

## Prerequisites

This tutorial assumes you're comfortable writing Ruby. You don't need any prior experience with AI APIs or LLMs — that's what we're here for.

If you'd like a Ruby refresher, [The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby) and [ruby.dev](https://ruby.dev/) are great starting points.

:::info
RubyLLM works in any Ruby context — plain scripts, Rails apps, Sinatra, background jobs. This tutorial focuses on core Ruby to keep examples clear and provider-agnostic.
:::

## What Makes RubyLLM Different?

Most AI SDKs expose you to the raw HTTP API: you build message arrays, handle token limits, parse JSON, and manage state yourself. RubyLLM abstracts all of that:

- **One interface, many providers** — switch from GPT-4o to Claude Sonnet by changing a model name string
- **Conversations are objects** — history, context, and state are managed for you
- **Tools are Ruby classes** — define a tool the same way you'd write any Ruby class
- **Streaming is a block** — `chat.ask("...") { |chunk| print chunk.text }`

Let's get started.
