#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Create a Calculator tool that the AI can use.
#
# A RubyLLM tool is a Ruby class that:
#   1. Inherits from RubyLLM::Tool
#   2. Has a `description` (tells the AI what this tool does)
#   3. Defines parameters with `param`
#   4. Implements `execute` with keyword arguments
#
# Example:
#   class MyTool < RubyLLM::Tool
#     description "What this tool does"
#     param :input_name, desc: "What this input is for"
#     def execute(input_name:)
#       # return the result
#     end
#   end
#
# Your Calculator should:
#   - Accept an :expression parameter (a math expression as a string)
#   - Evaluate it and return the result
#   - Handle errors gracefully

class Calculator
  # Transform this into a RubyLLM::Tool!
  def calculate(expression)
    eval(expression).to_s
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
