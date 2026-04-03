#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

puts "=== Multi-Modal Chat ==="
puts

chat = RubyLLM.chat

# Step 1: Ask with attachment — document enters conversation context
response = chat.ask("Summarize this quarterly report in 3 bullet points.",
                    with: "chat/report.txt")
puts response.content
puts "(#{response.input_tokens} input tokens)"
puts

# Step 2: Follow-up — no need to attach again
response = chat.ask("Which product line had the highest year-over-year growth?")
puts response.content
puts

# Step 3: Extract structured data
response = chat.ask("List each product line and its revenue as a simple table.")
puts response.content
