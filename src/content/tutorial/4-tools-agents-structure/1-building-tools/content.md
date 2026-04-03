---
type: lesson
title: Building Tools
focus: /workspace/tools_agents/calculator_tool.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Building Tools

Tools let AI models **call your Ruby code**. Instead of hallucinating answers, the model can invoke a tool to get real data. You define what the tool does, the AI decides when to call it.

## The Flow

```
You ask a question → AI decides it needs a tool → AI calls your tool
→ Tool returns a result → AI uses the result to answer
```

## Anatomy of a Tool

A RubyLLM tool is a Ruby class with three parts:

```ruby
class Weather < RubyLLM::Tool
  description "Gets current weather for a location"   # 1. What it does

  param :city, desc: "City name"                       # 2. What input it needs

  def execute(city:)                                   # 3. What it does when called
    { temperature: 72, conditions: "sunny" }
  end
end
```

No JSON schema, no API registration. Just a Ruby class.

## Your Task

Open `calculator_tool.rb`. There's a plain `Calculator` class at the top. **Transform it into a RubyLLM tool** by:

1. Inheriting from `RubyLLM::Tool`
2. Adding a `description`
3. Defining the `:expression` parameter with `param`
4. Renaming `calculate` to `execute` with a keyword argument

```ruby title="calculator_tool.rb" ins={1-10}
class Calculator < RubyLLM::Tool
  description "Evaluates mathematical expressions and returns the result"

  param :expression, desc: "A mathematical expression to evaluate (e.g., '2 + 3 * 4')"

  def execute(expression:)
    result = eval(expression)
    result.to_s
  rescue => e
    "Error: #{e.message}"
  end
end
```

The bottom of the script already wires it up with a chat. Run it:

```bash
$ ruby calculator_tool.rb
```

You should see the AI call your Calculator tool, then use the result to answer.

## Advanced Parameters

For tools with complex inputs, use the `params` block:

```ruby
class Scheduler < RubyLLM::Tool
  description "Books a meeting"

  params do
    object :window, description: "Time window" do
      string :start, description: "ISO8601 start time"
      string :finish, description: "ISO8601 end time"
    end
    array :attendees, of: :string, description: "Email addresses"
  end

  def execute(window:, attendees:)
    # book the meeting
  end
end
```

## Tool Call Controls

```ruby
chat.with_tools(Calculator, Weather, choice: :auto)      # AI decides (default)
chat.with_tools(Calculator, Weather, choice: :required)   # must use a tool
chat.with_tools(Calculator, Weather, choice: :calculator) # force specific tool
```

## Custom Initialization

Tools can have constructors for dependency injection:

```ruby
class DocumentSearch < RubyLLM::Tool
  description "Searches a document database"
  param :query, desc: "Search query"

  def initialize(database)
    @database = database
  end

  def execute(query:)
    @database.search(query)
  end
end

# Pass an instance instead of the class
search = DocumentSearch.new(my_database)
chat.with_tool(search)
```

## Stopping After a Tool Call

Sometimes a tool should write something and you want to skip the LLM's summary step. Use `halt` to return immediately without sending the result back through the model:

```ruby
class SaveFile < RubyLLM::Tool
  description "Saves content to a file"
  param :path, desc: "File path"
  param :content, desc: "Content to save"

  def execute(path:, content:)
    File.write(path, content)
    halt "Saved #{content.length} bytes to #{path}"
  end
end
```

With `halt`, the string is returned directly to your code — the model never sees it. Without `halt`, the result goes back to the model which generates a natural language response.

## Error Handling

Return a hash with an `error` key for **recoverable errors** — the model can read the error and try again with corrected parameters:

```ruby
def execute(location:)
  return { error: "Location must be at least 3 characters" } if location.length < 3
  fetch_weather(location)
end
```

Raise exceptions for **unrecoverable errors** — missing API keys, broken dependencies:

```ruby
def execute(query:)
  raise "DATABASE_URL not set" unless ENV["DATABASE_URL"]
  @db.search(query)
end
```

The distinction matters: a recoverable error lets the AI retry with different arguments; an unrecoverable one should stop execution immediately.
