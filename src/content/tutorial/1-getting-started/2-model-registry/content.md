---
type: lesson
title: Exploring the Model Registry
focus: /workspace/getting_started/explore_models.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Exploring the Model Registry

RubyLLM ships with a **built-in registry** of 600+ models across all supported providers. The registry is bundled with the gem — no API calls or keys needed to browse it.

## The Registry API

```ruby
RubyLLM.models.all                    # every model
RubyLLM.models.chat_models            # chat/completion models
RubyLLM.models.embedding_models       # embedding models
RubyLLM.models.by_provider(:openai)   # filter by provider
RubyLLM.models.find("claude-sonnet-4-6")  # find specific model
```

## Your Task

Open `explore_models.rb` and write code to:

1. **Print the total number** of models in the registry
2. **List all providers** (unique, sorted)
3. **Print the first 10 chat models** with their id, provider, and context window
4. **Find a specific model** and display its details

```ruby title="explore_models.rb"
# 1. Total models
puts "Total models: #{RubyLLM.models.all.count}"

# 2. Providers
providers = RubyLLM.models.all.map(&:provider).uniq.sort
puts "Providers: #{providers.join(', ')}"

# 3. First 10 chat models
RubyLLM.models.chat_models.first(10).each do |model|
  puts "  %-30s %-12s %s tokens" % [model.id, model.provider, model.context_window]
end

# 4. Specific model details
model = RubyLLM.models.find("gpt-4o")
puts "  Context window: #{model.context_window} tokens"
puts "  Vision: #{model.supports_vision?}"
```

Run it:

```bash
$ ruby explore_models.rb
```

This works without any API keys — the data is bundled in the gem.

## Model Properties

Each model exposes rich metadata:

| Property | Description |
|----------|-------------|
| `.id` | Model identifier (e.g., `"claude-sonnet-4-6"`) |
| `.provider` | Provider name (e.g., `"anthropic"`) |
| `.context_window` | Max tokens the model can process |
| `.supports_vision?` | Can it analyze images? |
| `.supports_json_mode?` | Structured JSON output support? |
| `.input_price_per_million` | Cost per million input tokens |
| `.output_price_per_million` | Cost per million output tokens |

## Filtering with Enumerable

Since the registry returns arrays, you can chain Ruby's `Enumerable` methods:

```ruby
# Find all OpenAI models with vision support
RubyLLM.models.by_provider(:openai).select(&:supports_vision?)

# Find the cheapest chat model
RubyLLM.models.chat_models.min_by(&:input_price_per_million)

# Group models by provider
RubyLLM.models.all.group_by(&:provider).transform_values(&:count)

# Filter by model family
RubyLLM.models.by_family("claude3_sonnet")
```

## Custom Endpoints & Unlisted Models

Some deployments use custom API endpoints (Azure OpenAI, local Ollama, etc.) or models not yet in the registry. Use `assume_model_exists: true` to bypass registry validation:

```ruby
# Azure OpenAI endpoint
RubyLLM.configure do |config|
  config.openai_api_base = "https://YOUR_RESOURCE.openai.azure.com"
  config.openai_api_key  = ENV["AZURE_OPENAI_KEY"]
end

chat = RubyLLM.chat(
  model: "my-gpt4-deployment",
  provider: :openai,
  assume_model_exists: true
)
```

The `provider:` keyword is required when assuming existence — it tells RubyLLM which API format to use.

## Keeping the Registry Fresh

The bundled registry is a snapshot. To pull the latest models from all configured providers:

```ruby
RubyLLM.models.refresh!             # update in memory
RubyLLM.models.save_to_json         # persist to disk
```

In a Rails app, run this after initial setup. The `rake models:update` task is for gem maintainers only — use `refresh!` in application code.
