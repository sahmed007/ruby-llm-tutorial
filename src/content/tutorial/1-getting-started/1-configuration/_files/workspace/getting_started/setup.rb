#!/usr/bin/env ruby
require "ruby_llm"

# NOTE: Your API key is sent through a CORS proxy. This is a demo environment —
# do not use production keys. Use a temporary or low-limit key.

# TODO: Configure RubyLLM with your API keys.
#
# Only set keys for the providers you plan to use:
#
#   config.openai_api_key     — for GPT, DALL-E, embeddings
#   config.anthropic_api_key  — for Claude models
#   config.gemini_api_key     — for Gemini models
#
# Use ENV.fetch("KEY", nil) so the app won't crash if a key is missing.

RubyLLM.configure do |config|
  # Add your API key configuration here
end

# Verify it worked
puts "RubyLLM loaded successfully!"
puts "Version: #{RubyLLM::VERSION}"
puts "Available models: #{RubyLLM.models.all.count}"
