#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Use the model registry to explore available models.
#
# The registry lives at RubyLLM.models and has these methods:
#
#   RubyLLM.models.all                   — every registered model
#   RubyLLM.models.chat_models           — only chat/completion models
#   RubyLLM.models.embedding_models      — only embedding models
#   RubyLLM.models.by_provider(:openai)  — filter by provider
#   RubyLLM.models.by_family("claude3_sonnet") — filter by model family
#   RubyLLM.models.find("gpt-4o")        — find a specific model
#
# Each model has: .id, .provider, .context_window,
#   .supports_vision?, .input_price_per_million, .output_price_per_million
#
# Tasks:
#   1. Print the total number of models
#   2. Print a list of unique providers
#   3. Print the first 10 chat models (id, provider, context window)
#   4. Find and display details about a specific model
#   5. (Bonus) Find the cheapest chat model by input price

puts "=== RubyLLM Model Registry ==="
puts
# Your code here
