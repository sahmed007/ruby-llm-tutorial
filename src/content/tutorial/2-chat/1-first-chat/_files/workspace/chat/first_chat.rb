#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Create a chat and ask it a question.
#
# Steps:
#   1. Create a chat instance:    chat = RubyLLM.chat
#   2. Ask a question:            response = chat.ask("your question")
#   3. Print the response:        puts response.content
#
# The response object also has:
#   response.model_id       — which model answered
#   response.input_tokens   — tokens in your prompt
#   response.output_tokens  — tokens in the reply
#
# To pick a specific model:
#   chat = RubyLLM.chat(model: "claude-sonnet-4-6")

puts "=== Your First Chat ==="
puts
# Your code here
