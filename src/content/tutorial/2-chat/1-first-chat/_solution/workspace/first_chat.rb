require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

puts "=== Your First Chat ==="
puts

chat = RubyLLM.chat
response = chat.ask("What makes Ruby special as a programming language? Answer in 2-3 sentences.")

puts response.content
puts
puts "--- Details ---"
puts "Model:         #{response.model_id}"
puts "Input tokens:  #{response.input_tokens}"
puts "Output tokens: #{response.output_tokens}"
