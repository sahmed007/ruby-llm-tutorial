require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

puts "=== Streaming Response ==="
puts

chat = RubyLLM.chat

# Set up event handlers
chat.on_new_message do
  print "Assistant: "
end

chat.on_end_message do |message|
  puts
  puts
  puts "--- Stats ---"
  puts "Input tokens:  #{message.input_tokens}"
  puts "Output tokens: #{message.output_tokens}"
end

# Stream the response — each chunk prints as it arrives
chat.ask("Write a short haiku about Ruby programming.") do |chunk|
  print chunk.content
end
