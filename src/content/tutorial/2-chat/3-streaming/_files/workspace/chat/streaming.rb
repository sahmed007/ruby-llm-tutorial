require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Stream a response in real-time.
#
# Instead of waiting for the full response, pass a block to `ask`:
#
#   chat.ask("your question") do |chunk|
#     print chunk.content   # prints each fragment as it arrives
#   end
#
# The block receives Chunk objects with:
#   chunk.content     — a small text fragment
#   chunk.tool_calls  — present if the model is calling a tool
#
# Event handlers give you more control:
#   chat.on_new_message  { print "Assistant: " }
#   chat.on_end_message  { |msg| puts "\n[Done]" }
#
# The ask method still returns the complete message when finished.

puts "=== Streaming Response ==="
puts
# Your code here
