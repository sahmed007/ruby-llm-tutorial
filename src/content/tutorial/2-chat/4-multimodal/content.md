---
type: lesson
title: Multi-Modal Input
focus: /workspace/chat/multimodal.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Multi-Modal Input

RubyLLM isn't limited to text. You can send **files alongside your messages** — images, documents, PDFs, audio, and more. The same `ask` method handles it all with one extra keyword argument.

## The `with:` Keyword

```ruby
chat = RubyLLM.chat

# Attach a single file
response = chat.ask("Summarize this document", with: "report.txt")

# Attach multiple files
response = chat.ask("Compare these two reports", with: ["q3.pdf", "q4.pdf"])
```

Files are read, encoded, and sent to the model automatically. No manual base64 encoding or MIME-type handling required.

## Supported Formats

| Category | Extensions |
|----------|-----------|
| Images | `.jpg`, `.png`, `.gif`, `.webp`, `.bmp` |
| Documents | `.pdf`, `.txt`, `.md`, `.csv`, `.json`, `.xml` |
| Code | `.rb`, `.py`, `.js`, `.html`, `.css` |
| Audio | `.mp3`, `.wav`, `.m4a`, `.ogg` (Gemini only) |
| Video | `.mp4`, `.mov`, `.avi`, `.webm` (Gemini only) |

## Your Task

A sample quarterly report is at `report.txt`. Open `multimodal.rb` and:

1. **Ask the AI to summarize** the document by passing it with `with: "report.txt"`
2. **Ask a follow-up question** about specific data — the document stays in context for the whole conversation
3. **Print token usage** from the response metadata

```ruby title="chat/multimodal.rb" ins={4-10}
chat = RubyLLM.chat

# Ask about the document
response = chat.ask("Summarize this quarterly report in 3 bullet points.",
                    with: "report.txt")
puts response.content
puts "(#{response.input_tokens} input tokens)"
puts

# Follow-up — document is already in context, no need to attach again
response = chat.ask("Which product line had the highest growth?")
puts response.content
```

Run it:

```bash
$ ruby chat/multimodal.rb
```

:::tip
After the first message with the attachment, the document is in the conversation history. Follow-up questions don't need `with:` again.
:::

## Images

The same API works for images:

```ruby
chat = RubyLLM.chat(model: "gpt-4o")

response = chat.ask("What's in this image?", with: "screenshot.png")
puts response.content

# Ask follow-up questions about the image
response = chat.ask("What colors are dominant?")
puts response.content
```

Vision models (GPT-4o, Claude 3, Gemini) can describe, compare, and reason about visual content.

## PDFs and Code Files

```ruby
# Analyze a PDF document
response = chat.ask("Extract all action items from this meeting notes PDF",
                    with: "meeting_notes.pdf")

# Review source code
response = chat.ask("Find any potential bugs in this file",
                    with: "app/models/user.rb")
```

:::note
Vision and document analysis require a model with vision support. Check `model.supports_vision?` in the registry. Most modern GPT-4 and Claude 3 models support it.
:::

## Cost Awareness

Documents and images consume significant input tokens. The `report.txt` in this lesson is a few hundred tokens — a 50-page PDF might be tens of thousands. Check `response.input_tokens` and compare against model pricing:

```ruby
response = chat.ask("Analyze this", with: "big_document.pdf")
model = RubyLLM.models.find(response.model_id)
cost = response.input_tokens * model.input_price_per_million / 1_000_000
puts "This message cost approximately $#{cost.round(4)}"
```
