#!/usr/bin/env ruby
require "ruby_llm"

# NOTE: Your API key is sent through a CORS proxy. This is a demo environment —
# do not use production keys. Use a temporary or low-limit key.

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  config.anthropic_api_key = ENV.fetch("ANTHROPIC_API_KEY", nil)
  config.gemini_api_key = ENV.fetch("GEMINI_API_KEY", nil)
end

# Verify it worked
puts "RubyLLM loaded successfully!"
puts "Version: #{RubyLLM::VERSION}"
puts "Available models: #{RubyLLM.models.all.count}"
