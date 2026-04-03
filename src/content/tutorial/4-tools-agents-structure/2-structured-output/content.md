---
type: lesson
title: Structured Output
focus: /workspace/tools_agents/structured_output.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Structured Output

Getting free-form text from an AI is great, but sometimes you need **predictable, typed data**. RubyLLM's structured output uses schemas to guarantee the shape of the response.

## The Problem

```ruby
response = chat.ask("Extract the person's name and age from: 'Alice is 30'")
response.content  # => "The person's name is Alice and they are 30 years old."
# Now you have to parse this string... not ideal.
```

## The Solution

```ruby
response = chat.with_schema(PersonSchema).ask("Extract from: 'Alice is 30'")
response.content  # => {"name" => "Alice", "age" => 30}
# Clean, typed data.
```

## Defining Schemas

A schema describes the shape of data you want back:

```ruby
class PersonSchema < RubyLLM::Schema
  string :name, description: "Person's full name"
  integer :age, description: "Person's age in years"
  string :city, required: false  # optional field
end
```

Available types: `string`, `integer`, `number` (float), `boolean`, `array`, `object`.

## Your Task

Open `structured_output.rb` and:

1. **Define a `PersonSchema`** with fields for name, age, occupation, and city
2. **Use it with a chat** via `chat.with_schema(PersonSchema)`
3. **Print the extracted data**

```ruby title="structured_output.rb"
class PersonSchema < RubyLLM::Schema
  string :name, description: "Person's full name"
  integer :age, description: "Person's age in years"
  string :occupation, description: "What they do for work"
  string :city, description: "Where they live"
end

chat = RubyLLM.chat
response = chat.with_schema(PersonSchema)
               .ask("Extract the person's information from this text: #{sample_text}")

response.content.each do |key, value|
  puts "  %-12s %s" % [key + ":", value]
end
```

Run it:

```bash
$ ruby structured_output.rb
```

## Manual JSON Schema

You can also pass a raw hash instead of defining a class:

```ruby
schema = {
  type: "object",
  properties: {
    name: { type: "string" },
    age: { type: "integer" },
    tags: { type: "array", items: { type: "string" } }
  },
  required: ["name", "age"]
}

response = chat.with_schema(schema).ask("Extract info from: ...")
```

## Nested Schemas

Schemas support nested objects and arrays:

```ruby
class RecipeSchema < RubyLLM::Schema
  string :title, description: "Recipe name"
  integer :prep_time, description: "Prep time in minutes"
  array :ingredients, of: :string, description: "List of ingredients"
  object :nutrition, description: "Nutritional info" do
    integer :calories
    number :protein, description: "Grams of protein"
  end
end
```

This is powerful for building data extraction pipelines, form auto-fill, and content classification — all returning clean, typed Ruby data.
