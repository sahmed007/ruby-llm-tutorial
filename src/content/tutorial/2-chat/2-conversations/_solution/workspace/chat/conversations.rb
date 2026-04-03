#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

puts "=== Multi-Turn Conversation ==="
puts

chat = RubyLLM.chat
chat.with_instructions("You are a friendly Ruby expert. Keep answers concise — under 3 sentences.")
chat.with_temperature(0.7)

# First question
response = chat.ask("What are blocks in Ruby?")
puts "Q: What are blocks in Ruby?"
puts "A: #{response.content}"
puts

# Follow-up — the AI remembers the previous exchange
response = chat.ask("Can you show me a simple example?")
puts "Q: Can you show me a simple example?"
puts "A: #{response.content}"
puts

# Another follow-up
response = chat.ask("How is that different from a Proc?")
puts "Q: How is that different from a Proc?"
puts "A: #{response.content}"
puts

# Print full conversation history
puts "--- Full Conversation History ---"
chat.messages.each do |msg|
  puts "[#{msg.role}] #{msg.content.to_s.lines.first&.strip}"
end
