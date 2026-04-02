---
type: lesson
title: Image Generation
focus: /workspace/paint.rb
custom:
  shell:
    workdir: "/workspace"
---

# Image Generation

RubyLLM generates images from text descriptions with `RubyLLM.paint`. Same simple API — one method, works across providers.

## The Basics

```ruby
image = RubyLLM.paint("A red panda writing Ruby code in a cozy cafe")

image.url              # => "https://..."
image.revised_prompt   # => the model's refined version of your prompt
image.model_id         # => "dall-e-3"
```

Save to a file:

```ruby
image.save("output.png")
```

## Your Task

Open `paint.rb` and generate an image:

1. **Call `RubyLLM.paint`** with the prompt
2. **Print the URL** and model info
3. Optionally print the revised prompt

```ruby title="paint.rb"
image = RubyLLM.paint(prompt)

puts "Image URL: #{image.url}"
puts "Model:     #{image.model_id}"

if image.revised_prompt
  puts "Revised prompt: #{image.revised_prompt}"
end
```

Run it:

```bash
$ ruby paint.rb
```

:::note
Requires an OpenAI API key with DALL-E access.
:::

## Image Options

### Size

```ruby
RubyLLM.paint("a fluffy cat", size: "1024x1024")     # Square
RubyLLM.paint("a landscape", size: "1792x1024")      # Landscape
RubyLLM.paint("a portrait", size: "1024x1792")       # Portrait
```

### Models

```ruby
RubyLLM.paint("prompt", model: "dall-e-3")
RubyLLM.paint("prompt", model: "imagen-3.0-generate-002")  # Google

# Set default globally
RubyLLM.configure do |config|
  config.default_image_model = "dall-e-3"
end
```

## Working with Image Data

```ruby
image = RubyLLM.paint("Abstract geometric patterns")

# Raw binary data
blob = image.to_blob
puts "Size: #{blob.bytesize} bytes"

# Check encoding
if image.base64?
  puts "MIME type: #{image.mime_type}"
end
```

## Prompt Engineering Tips

Quality of your prompt directly affects the output:

```ruby
# Vague
RubyLLM.paint("dog")

# Descriptive — much better
RubyLLM.paint(
  "A golden retriever puppy playing fetch in a sunny park, " \
  "shallow depth of field, DSLR photography"
)

# Style-directed
RubyLLM.paint(
  "A mountain range at sunset, oil painting in the style of Bob Ross"
)
```

## Error Handling

```ruby
begin
  image = RubyLLM.paint("Your prompt")
rescue RubyLLM::BadRequestError => e
  puts "Content policy violation: #{e.message}"
rescue RubyLLM::Error => e
  puts "Generation failed: #{e.message}"
end
```
