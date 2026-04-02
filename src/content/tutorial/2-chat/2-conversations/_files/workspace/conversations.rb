require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Build a multi-turn conversation with a system instruction.
#
# Steps:
#   1. Create a chat:   chat = RubyLLM.chat
#   2. Set a persona:   chat.with_instructions("You are a ...")
#   3. Ask multiple questions — the AI remembers previous exchanges
#   4. Print the conversation history using chat.messages
#
# chat.messages returns an array of message objects with:
#   message.role    — :system, :user, or :assistant
#   message.content — the text
#
# You can also control creativity:
#   chat.with_temperature(0.2)  — factual, consistent
#   chat.with_temperature(0.9)  — creative, varied

puts "=== Multi-Turn Conversation ==="
puts
# Your code here
