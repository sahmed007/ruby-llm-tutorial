---
type: lesson
title: Your First Chat
focus: /workspace/first_chat.rb
custom:
  shell:
    workdir: "/workspace"
---

# Your First Chat

The heart of RubyLLM is `RubyLLM.chat`. Three lines of code is all you need:

```ruby
chat = RubyLLM.chat
response = chat.ask("What is Ruby?")
puts response.content
```

RubyLLM picks a sensible default model, sends your prompt, and returns a response object.

## The Response Object

Every call to `chat.ask(...)` returns a response with useful metadata:

| Property | What it contains |
|----------|-----------------|
| `response.content` | The AI's text reply |
| `response.model_id` | Which model generated the response |
| `response.input_tokens` | Tokens your prompt used |
| `response.output_tokens` | Tokens the reply used |

## Your Task

Open `first_chat.rb` and:

1. **Create a chat** with `RubyLLM.chat`
2. **Ask a question** with `chat.ask("...")`
3. **Print the response** content and metadata

```ruby title="first_chat.rb"
chat = RubyLLM.chat
response = chat.ask("What makes Ruby special as a programming language? Answer in 2-3 sentences.")

puts response.content
puts
puts "Model:         #{response.model_id}"
puts "Input tokens:  #{response.input_tokens}"
puts "Output tokens: #{response.output_tokens}"
```

Run it:

```bash
$ ruby first_chat.rb
```

:::note
This requires a configured API key. If you don't have one, the code pattern is still the important takeaway.
:::

## Choosing a Model

Pass a model ID to use a specific model:

```ruby
chat = RubyLLM.chat(model: "claude-sonnet-4-6")  # Anthropic
chat = RubyLLM.chat(model: "gpt-4o")             # OpenAI
chat = RubyLLM.chat(model: "gemini-2.0-flash")   # Google
```

You can even switch models mid-conversation:

```ruby
chat = RubyLLM.chat(model: "gpt-4o")
chat.ask("What is Ruby?")

chat.with_model("claude-sonnet-4-6")
chat.ask("Now explain it differently")
```

The conversation history carries over — the new model sees everything the previous one said.
