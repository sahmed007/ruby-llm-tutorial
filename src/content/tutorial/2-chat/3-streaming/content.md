---
type: lesson
title: Streaming Responses
focus: /workspace/streaming.rb
custom:
  shell:
    workdir: "/workspace"
---

# Streaming Responses

When you call `chat.ask(...)` normally, Ruby blocks until the entire response is generated. For long responses, that means staring at a blank screen. **Streaming** delivers the response chunk by chunk as the AI generates it.

## The Pattern: Pass a Block

```ruby
chat = RubyLLM.chat

# Without streaming — waits for complete response
response = chat.ask("Write a poem")
puts response.content

# With streaming — prints word by word
response = chat.ask("Write a poem") do |chunk|
  print chunk.content
end
```

The block receives `Chunk` objects as they arrive. `ask` still returns the complete response when finished.

## Your Task

Open `streaming.rb` and implement streaming with event handlers:

1. **Set up event handlers** for `on_new_message` and `on_end_message`
2. **Ask a question with a block** to stream the response

```ruby title="streaming.rb"
chat = RubyLLM.chat

chat.on_new_message do
  print "Assistant: "
end

chat.on_end_message do |message|
  puts
  puts "Input tokens:  #{message.input_tokens}"
  puts "Output tokens: #{message.output_tokens}"
end

chat.ask("Write a short haiku about Ruby programming.") do |chunk|
  print chunk.content
end
```

Run it:

```bash
$ ruby streaming.rb
```

You should see the response appear word by word instead of all at once.

## Event Handlers

| Handler | When it fires |
|---------|--------------|
| `on_new_message` | Before the first chunk arrives |
| `on_end_message` | After the last chunk, with the complete message |
| `on_tool_call` | When the model invokes a tool |
| `on_tool_result` | When a tool returns its result |

## Error Handling

```ruby
begin
  chat.ask("Generate a long response") do |chunk|
    print chunk.content
  end
rescue RubyLLM::Error => e
  puts "\nStreaming error: #{e.message}"
end
```

## Real-World Usage

In web apps, you'd push chunks to the client using **Server-Sent Events** or **WebSockets**:

```ruby
# SSE example
chat.ask(prompt) do |chunk|
  sse.write(chunk.content, event: "message")
end

# Turbo Streams example
chat.ask(prompt) do |chunk|
  Turbo::StreamsChannel.broadcast_append_to(
    "chat_#{id}", target: "response", html: chunk.content
  )
end
```
