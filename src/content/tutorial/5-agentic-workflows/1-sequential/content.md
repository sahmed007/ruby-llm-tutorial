---
type: lesson
title: Sequential Workflows
focus: /workspace/agentic_workflows/sequential.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Sequential Workflows

A single agent can do a lot, but some problems are better solved by **a chain of specialists**. Sequential workflows pass the output from one agent as the input to the next — like an assembly line where each station adds value.

## Why Chain Agents?

Each agent has focused instructions, a suitable model, and the right temperature for its job:

```
ResearchAgent (low temp, factual)
    ↓ structured facts
WriterAgent (higher temp, creative)
    ↓ polished prose
```

A single "do everything" agent usually produces mediocre results at every step. Specialists produce better output at each stage.

## The Pattern

Orchestration is **regular Ruby code** — no framework or DSL required:

```ruby
class ResearchAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.2
  instructions "You are a research assistant. Provide key facts and context."
end

class WriterAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.7
  instructions "You transform research notes into clear, engaging prose."
end

# Orchestration — just Ruby
topic = "How Ruby's garbage collector works"

researcher = ResearchAgent.new
research = researcher.ask("Research this topic: #{topic}").content

writer = WriterAgent.new
article = writer.ask("Write a blog post from these notes:\n\n#{research}").content

puts article
```

Each agent is a separate object with its own conversation history. The output of one becomes the input of the next.

## Your Task

Open `sequential.rb`. Two agents are defined — `ResearchAgent` and `WriterAgent`. Implement the workflow:

1. **Instantiate `ResearchAgent`** and ask it to research the given topic
2. **Pass the research output** to `WriterAgent` as the basis for a blog post
3. **Print both outputs** — research notes first, then the polished article

```ruby title="agentic_workflows/sequential.rb" ins={3-13}
TOPIC = "Ruby's object model and why everything is an object"

puts "--- Phase 1: Research ---"
researcher = ResearchAgent.new
research = researcher.ask("Research this topic thoroughly: #{TOPIC}")
puts research.content
puts

puts "--- Phase 2: Writing ---"
writer = WriterAgent.new
article = writer.ask(
  "Transform these research notes into a concise 2-paragraph blog post:\n\n#{research.content}"
)
puts article.content
```

Run it:

```bash
$ ruby agentic_workflows/sequential.rb
```

## Adding More Stages

Extend the pipeline by adding agents:

```ruby
class EditorAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.1
  instructions <<~PROMPT
    You are a technical editor. Review this blog post for:
    - Technical accuracy
    - Grammar and clarity
    - Appropriate length (under 300 words)
    Return the improved version directly.
  PROMPT
end

# Three-stage pipeline
research = ResearchAgent.new.ask("Research: #{topic}").content
draft = WriterAgent.new.ask("Write from:\n#{research}").content
final = EditorAgent.new.ask("Edit this:\n#{draft}").content
```

## Keeping Context Between Stages

Sometimes you want one agent to accumulate context across stages. Use the same instance:

```ruby
analyst = AnalystAgent.new

# Feed data in multiple messages
%w[sales_q1 sales_q2 sales_q3].each do |file|
  analyst.ask("Here's #{file} data: #{load(file)}")
end

# Final synthesis — agent has all three quarters in context
summary = analyst.ask("Now summarize the year-to-date trends").content
```

This is different from chaining — here a single agent builds up knowledge across messages.

## Error Handling in Pipelines

Wrap stages in `begin/rescue` so one failure doesn't kill the whole pipeline:

```ruby
begin
  research = ResearchAgent.new.ask("Research: #{topic}").content
rescue RubyLLM::Error => e
  puts "Research failed: #{e.message}"
  research = "Research unavailable — write from general knowledge."
end

article = WriterAgent.new.ask("Write from:\n#{research}").content
```
