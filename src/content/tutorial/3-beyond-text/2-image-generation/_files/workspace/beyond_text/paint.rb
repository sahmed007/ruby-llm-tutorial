#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Generate an image using RubyLLM.paint
#
# Basic usage:
#   image = RubyLLM.paint("A description of what you want")
#
# The image object provides:
#   image.url              — URL to the generated image
#   image.revised_prompt   — the model's refined version of your prompt
#   image.model_id         — which model generated it
#   image.base64?          — whether returned as base64 data
#
# Options:
#   RubyLLM.paint("prompt", model: "dall-e-3", size: "1024x1024")
#
# Save to file:
#   image.save("output.png")
#
# Get raw binary:
#   blob = image.to_blob

prompt = "A photorealistic red panda writing Ruby code on a laptop in a cozy cafe"

puts "=== Image Generation ==="
puts
puts "Prompt: #{prompt}"
puts
# Your code here
