---
type: lesson
title: Installation & Configuration
focus: /workspace/setup.rb
custom:
  shell:
    workdir: "/workspace"
---

# Installation & Configuration

RubyLLM is a Ruby gem that gives you a **single, elegant interface** to work with multiple AI providers — OpenAI, Anthropic, Google Gemini, and more. Instead of learning a different SDK for each provider, you learn one API and swap models freely.

## Installing the Gem

In any Ruby project, add RubyLLM to your `Gemfile`:

```ruby
gem "ruby_llm"
```

Then run `bundle install`. That's it — no provider-specific gems needed.

:::info
In this tutorial environment, `ruby_llm` is already installed and ready to use.
:::

## Configuration

Open `setup.rb` in the editor. RubyLLM needs API keys to talk to providers. Complete the `configure` block:

```ruby title="setup.rb" ins={3-5}
RubyLLM.configure do |config|
  # Add your API key configuration here
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  config.anthropic_api_key = ENV.fetch("ANTHROPIC_API_KEY", nil)
  config.gemini_api_key = ENV.fetch("GEMINI_API_KEY", nil)
end
```

You only need keys for providers you plan to use:

| Provider | Config key | Models |
|----------|-----------|--------|
| OpenAI | `config.openai_api_key` | GPT-4o, o1, DALL-E |
| Anthropic | `config.anthropic_api_key` | Claude Sonnet, Opus, Haiku |
| Google | `config.gemini_api_key` | Gemini Pro, Flash |

Run the script to verify:

```bash
$ ruby setup.rb
```

:::tip
Using `ENV.fetch("KEY", nil)` means the script won't crash if a key is missing — it just won't be able to use that provider.
:::

## What Makes RubyLLM Different?

- **One interface, many providers** — switch from GPT to Claude by changing a model name
- **Conversation history is automatic** — no manual message array management
- **Tools are just Ruby classes** — no JSON schema boilerplate
- **Streaming, embeddings, and image generation** — all built in
