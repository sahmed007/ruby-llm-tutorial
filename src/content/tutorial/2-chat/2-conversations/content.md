---
type: lesson
title: Conversations & Context
focus: /workspace/conversations.rb
custom:
  shell:
    workdir: "/workspace"
---

# Conversations & Context

A single `chat.ask` is useful, but the real power is **multi-turn conversations**. The chat object automatically manages history — every message you send and every response you receive is remembered.

## How Context Works

```ruby
chat = RubyLLM.chat

chat.ask "My name is Alice"
# => "Nice to meet you, Alice!"

chat.ask "What's my name?"
# => "Your name is Alice!"
```

Each `ask` sends the **entire conversation history** to the model. The AI sees every previous exchange naturally.

## System Instructions

Set the AI's behavior with `with_instructions`:

```ruby
chat = RubyLLM.chat
chat.with_instructions "You are a pirate. Always respond in pirate speak."
chat.ask "What is Ruby?"
# => "Arrr! Ruby be a fine programming language, matey! ..."
```

You can also append to existing instructions:

```ruby
chat.with_instructions "Keep responses under 2 sentences.", append: true
```

## Your Task

Open `conversations.rb` and build a multi-turn conversation:

1. **Create a chat** and set a system instruction with `with_instructions`
2. **Ask multiple follow-up questions** — the AI should reference previous answers
3. **Print the conversation history** with `chat.messages`

```ruby title="conversations.rb"
chat = RubyLLM.chat
chat.with_instructions("You are a friendly Ruby expert. Keep answers concise — under 3 sentences.")
chat.with_temperature(0.7)

response = chat.ask("What are blocks in Ruby?")
puts "A: #{response.content}"

response = chat.ask("Can you show me a simple example?")
puts "A: #{response.content}"

response = chat.ask("How is that different from a Proc?")
puts "A: #{response.content}"

# Print full history
chat.messages.each do |msg|
  puts "[#{msg.role}] #{msg.content.to_s.lines.first&.strip}"
end
```

Run it:

```bash
$ ruby conversations.rb
```

## Accessing History

`chat.messages` returns every message in the conversation:

```ruby
chat.messages.each do |msg|
  puts "[#{msg.role}] #{msg.content}"
end
# [system] You are a friendly Ruby expert...
# [user] What are blocks?
# [assistant] Blocks are anonymous functions...
```

Each message has a `role` (`:system`, `:user`, or `:assistant`) and `content`.

## Temperature Control

```ruby
# Low — factual, consistent answers
chat = RubyLLM.chat.with_temperature(0.2)

# High — creative, varied responses
chat = RubyLLM.chat.with_temperature(0.9)
```

Temperature ranges from 0 (deterministic) to 1+ (creative). Default is usually around 0.7.
