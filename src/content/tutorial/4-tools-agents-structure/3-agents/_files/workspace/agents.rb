require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# --- Tools for our agent to use ---

class Calculator < RubyLLM::Tool
  description "Evaluates mathematical expressions"
  param :expression, desc: "A math expression (e.g., '2 + 3 * 4')"

  def execute(expression:)
    eval(expression).to_s
  rescue => e
    "Error: #{e.message}"
  end
end

class UnitConverter < RubyLLM::Tool
  description "Converts between common units of measurement"

  param :value, type: :number, desc: "The numeric value to convert"
  param :from_unit, desc: "Source unit (e.g., 'km', 'miles', 'celsius', 'fahrenheit', 'kg', 'pounds')"
  param :to_unit, desc: "Target unit"

  CONVERSIONS = {
    ["km", "miles"] => ->(v) { v * 0.621371 },
    ["miles", "km"] => ->(v) { v * 1.60934 },
    ["celsius", "fahrenheit"] => ->(v) { v * 9.0 / 5.0 + 32 },
    ["fahrenheit", "celsius"] => ->(v) { (v - 32) * 5.0 / 9.0 },
    ["kg", "pounds"] => ->(v) { v * 2.20462 },
    ["pounds", "kg"] => ->(v) { v * 0.453592 },
  }

  def execute(value:, from_unit:, to_unit:)
    converter = CONVERSIONS[[from_unit.downcase, to_unit.downcase]]
    return "Unknown conversion: #{from_unit} to #{to_unit}" unless converter
    result = converter.call(value.to_f)
    "#{value} #{from_unit} = #{result.round(4)} #{to_unit}"
  end
end

# TODO: Create a reusable Agent class.
#
# An Agent bundles model, instructions, tools, and settings
# into a reusable class. Available DSL methods:
#
#   class MyAgent < RubyLLM::Agent
#     model "gpt-4o"                          # which AI model
#     instructions "You are a ..."            # system prompt
#     tools ToolA, ToolB                      # available tools
#     temperature 0.3                         # creativity (0-1)
#     params max_output_tokens: 256           # provider-specific options
#   end
#
# Use it:
#   agent = MyAgent.new
#   response = agent.ask("question")
#
# Create a MathAssistant agent that:
#   - Uses the Calculator and UnitConverter tools
#   - Has instructions to show its work step by step
#   - Uses a low temperature for accuracy

# Your agent class here

puts "=== Agent Demo ==="
puts

# Once you've defined MathAssistant, uncomment these lines:
#
# agent = MathAssistant.new
#
# agent.on_tool_call do |tc|
#   puts "  [tool: #{tc.name}(#{tc.arguments})]"
# end
#
# agent.on_tool_result do |result|
#   puts "  [result: #{result}]"
# end
#
# puts "Q: What is 42 km in miles, and then square that number?"
# response = agent.ask("What is 42 km in miles, and then square that number?")
# puts
# puts response.content
# puts
#
# # The agent remembers context — ask a follow-up:
# puts "Q: Now convert that back to a round number in km"
# response = agent.ask("Now convert that back to a round number in km")
# puts
# puts response.content
