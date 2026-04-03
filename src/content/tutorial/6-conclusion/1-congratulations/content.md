---
type: lesson
title: Congratulations
editor: false
terminal: false
previews: false
---

# You've Completed the RubyLLM Tutorial

You started with a blank Ruby environment and worked your way through the full surface area of RubyLLM — from a simple chat call to multi-step agentic workflows running entirely in your browser.

## What You Built

Here's everything you covered:

- **Configuration** — connected RubyLLM to AI providers and tuned model defaults
- **Model Registry** — explored and compared models across providers programmatically
- **Chat & Conversations** — built multi-turn conversations with persistent context
- **Streaming** — received responses token-by-token using a simple block interface
- **Multimodal Input** — sent images and files alongside text messages
- **Embeddings** — generated vector representations and measured semantic similarity
- **Image Generation** — created images from text prompts with DALL-E and Imagen
- **Audio Transcription** — converted speech to text with Whisper and GPT-4o Transcribe
- **Tools** — defined Ruby classes as callable tools with automatic schema generation
- **Structured Output** — extracted typed data from unstructured text
- **Agents** — built autonomous agents that reason, plan, and call tools in a loop
- **Agentic Workflows** — composed sequential pipelines and self-evaluating feedback loops

## What to Build Next

RubyLLM is designed to drop into any Ruby context. Here are some natural next steps:

**Add AI to a Rails app**

```ruby
# app/controllers/chats_controller.rb
def create
  chat = RubyLLM::Chat.new
  @response = chat.ask(params[:message])
  render json: { message: @response.content }
end
```

**Build a RAG pipeline**

Combine embeddings with a vector database (pgvector, Weaviate, Qdrant) to give your model access to your own documents.

**Run tools in background jobs**

Wrap long-running tool calls in Sidekiq or Solid Queue so agents can do real work without blocking your web process.

:::tip
The [RubyLLM README](https://github.com/crmne/ruby_llm) covers Rails integration, ActiveRecord persistence for conversations, and streaming over ActionCable in detail.
:::

## Keep in Touch

RubyLLM is open source and actively developed. If you hit a bug, have a feature idea, or want to contribute:

- **GitHub:** [github.com/crmne/ruby_llm](https://github.com/crmne/ruby_llm)
- **RubyGems:** [rubygems.org/gems/ruby_llm](https://rubygems.org/gems/ruby_llm)

Thanks for following along. Now go build something with it.
