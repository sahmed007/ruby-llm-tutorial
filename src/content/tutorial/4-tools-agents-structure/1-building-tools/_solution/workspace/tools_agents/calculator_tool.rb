#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

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

# --- Use the tool with a chat ---
puts "=== AI with Tools ==="
puts

chat = RubyLLM.chat
chat.with_tool(Calculator)

chat.on_tool_call do |tool_call|
  puts "[Tool called: #{tool_call.name}(#{tool_call.arguments})]"
end

response = chat.ask("What is 1547 * 382 + 99?")
puts
puts "Answer: #{response.content}"
