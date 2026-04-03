---
type: lesson
title: Agents
focus: /workspace/tools_agents/agents.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Agents

In the Tools lesson you configured a chat with `chat.with_tool(...)`. That works for one-off usage, but if you need the same setup in multiple places, you'd repeat the configuration every time. **Agents** solve this — they bundle model, instructions, tools, and settings into a reusable class you define once and use anywhere.

## Chat vs. Agent

```ruby
# Manual setup — repeated every time you need this behavior
chat = RubyLLM.chat(model: "gpt-4o")
chat.with_instructions("You are a math assistant. Show your work.")
chat.with_tool(Calculator)
chat.with_tool(UnitConverter)
chat.with_temperature(0.2)
chat.ask("What is 42 km in miles?")

# Agent — define once, use anywhere
class MathAssistant < RubyLLM::Agent
  model "gpt-4o"
  instructions "You are a math assistant. Show your work."
  tools Calculator, UnitConverter
  temperature 0.2
end

MathAssistant.new.ask("What is 42 km in miles?")
```

## The Agent DSL

Every agent inherits from `RubyLLM::Agent` and uses class-level macros to declare its behavior:

| DSL method | Purpose | Example |
|------------|---------|---------|
| `model` | Which AI model to use | `model "gpt-4o"` |
| `instructions` | System prompt / persona | `instructions "You are a ..."` |
| `tools` | Which tools the agent can call | `tools Calculator, Weather` |
| `temperature` | Creativity level (0–1) | `temperature 0.3` |
| `params` | Provider-specific parameters | `params max_output_tokens: 256` |
| `headers` | Custom HTTP headers | `headers "x-custom" => "value"` |
| `schema` | Enforce structured output shape | `schema { string :verdict }` |
| `context` | Set global context | `context key: "value"` |
| `inputs` | Declare runtime inputs | `inputs :workspace` |

## Your Task

Open `agents.rb`. Two tools are already defined — `Calculator` and `UnitConverter`. Create a `MathAssistant` agent that uses both:

```ruby title="agents.rb" ins={1-6}
class MathAssistant < RubyLLM::Agent
  model "gpt-4o"
  instructions "You are a helpful math assistant. Show your work step by step. " \
               "Use the calculator for arithmetic and the unit converter for unit conversions."
  tools Calculator, UnitConverter
  temperature 0.2
end
```

Then uncomment the demo code at the bottom and run:

```bash
$ ruby agents.rb
```

The agent will chain tool calls — converting km to miles, then squaring the result — all automatically.

## Agent Instances and Memory

Each `new` creates a fresh conversation. Within one instance, the agent remembers everything:

```ruby
agent = MathAssistant.new
agent.ask("What is 100 fahrenheit in celsius?")
agent.ask("Now double that")  # remembers: 37.78°C → 75.56°C

# Fresh agent — separate memory
other = MathAssistant.new
other.ask("What is 5 * 5?")  # knows nothing about the first agent
```

You can also access the underlying chat object directly:

```ruby
agent = MathAssistant.new
agent.ask("Hello")

# Full chat API is available
agent.messages.each { |m| puts "[#{m.role}] #{m.content}" }
agent.chat  # => the underlying RubyLLM::Chat instance
```

## Event Handlers

Agents support the same callbacks as chats — useful for logging, debugging, or building UIs:

```ruby
agent = MathAssistant.new

agent.on_new_message { print "Agent: " }
agent.on_end_message { |msg| puts "\n[#{msg.output_tokens} tokens]" }

agent.on_tool_call do |tc|
  puts "Calling: #{tc.name}(#{tc.arguments})"
end

agent.on_tool_result do |result|
  puts "Tool returned: #{result}"
end

# Stream the response
agent.ask("What is 99 * 77?") { |chunk| print chunk.content }
```

## Structured Output with Agents

Use the `schema` DSL to guarantee the response shape:

```ruby
class ReviewAgent < RubyLLM::Agent
  model "gpt-4o"
  instructions "You review code and provide structured feedback."

  schema do
    string :verdict, enum: ["pass", "revise"]
    string :feedback
  end
end

response = ReviewAgent.new.ask("Review: def add(a,b) a+b end")
response.content
# => {"verdict" => "pass", "feedback" => "Clean and concise..."}
```

You can also reference a schema class or pass a hash:

```ruby
# Reference a schema class
class MyAgent < RubyLLM::Agent
  schema PersonSchema
end

# Or a raw hash
class MyAgent < RubyLLM::Agent
  schema type: "object", properties: { name: { type: "string" } }
end
```

## Runtime Inputs

Use `inputs` to declare values that vary per instantiation:

```ruby
class ProjectAssistant < RubyLLM::Agent
  inputs :project_name

  model "gpt-4o"
  instructions { "You are helping with the #{project_name} project." }
  temperature 0.5
end

agent = ProjectAssistant.new(project_name: "RubyLLM")
agent.ask("What should we work on next?")
```

Notice that `instructions` takes a **block** when it needs access to runtime inputs — the block is evaluated lazily when the agent is instantiated.

## Dynamic Tools

Tools can also be constructed dynamically using a block:

```ruby
class FlexibleAgent < RubyLLM::Agent
  model "gpt-4o"
  instructions "You are a helpful assistant."

  tools do
    available = [Calculator]
    available << UnitConverter if ENV["ENABLE_UNITS"]
    available
  end
end
```

This is useful when which tools are available depends on configuration, user permissions, or other runtime conditions.

## Provider-Specific Parameters

Pass provider-specific options with `params`:

```ruby
class PreciseAgent < RubyLLM::Agent
  model "gpt-4o"
  instructions "You are a precise assistant."
  params max_output_tokens: 256,
         response_format: { type: "json_object" }
end
```

## When to Use Agents vs. Chat

| Use `RubyLLM.chat` | Use `RubyLLM::Agent` |
|---------------------|----------------------|
| One-off, inline conversations | Reusable assistants with fixed behavior |
| Quick prototyping | Production code with defined personas |
| When setup varies each time | When setup is consistent across uses |
| Ad-hoc tool usage | Standard tool configurations |

Both have the same capabilities — agents are a class-based wrapper around the same chat API. Every `with_*` method available on a chat is also available on an agent instance.
