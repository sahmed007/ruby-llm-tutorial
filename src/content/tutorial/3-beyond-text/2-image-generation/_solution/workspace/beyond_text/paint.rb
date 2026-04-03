#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

prompt = "A photorealistic red panda writing Ruby code on a laptop in a cozy cafe"

puts "=== Image Generation ==="
puts
puts "Prompt: #{prompt}"
puts
puts "Generating..."

image = RubyLLM.paint(prompt)

puts
puts "Image URL: #{image.url}"
puts "Model:     #{image.model_id}"

if image.revised_prompt
  puts
  puts "Revised prompt: #{image.revised_prompt}"
end

# Uncomment to save locally:
# image.save("red_panda.png")
# puts "Saved to red_panda.png"
