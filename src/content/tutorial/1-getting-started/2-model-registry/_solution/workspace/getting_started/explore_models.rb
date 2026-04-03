#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

puts "=== RubyLLM Model Registry ==="
puts

# 1. Total models
puts "Total models: #{RubyLLM.models.all.count}"
puts

# 2. Providers
providers = RubyLLM.models.all.map(&:provider).uniq.sort
puts "Providers: #{providers.join(', ')}"
puts

# 3. First 10 chat models
puts "Chat Models (first 10):"
puts "-" * 60
RubyLLM.models.chat_models.first(10).each do |model|
  puts "  %-30s %-12s %s tokens" % [model.id, model.provider, model.context_window]
end
puts

# 4. Specific model details
model = RubyLLM.models.find("gpt-4o")
if model
  puts "Model Details: #{model.id}"
  puts "  Provider:       #{model.provider}"
  puts "  Context window: #{model.context_window} tokens"
  puts "  Vision:         #{model.supports_vision?}"
  puts "  Input price:    $#{model.input_price_per_million}/M tokens"
  puts "  Output price:   $#{model.output_price_per_million}/M tokens"
end
puts

# 5. Bonus: find the cheapest chat model
cheapest = RubyLLM.models.chat_models.min_by { |m| m.input_price_per_million || Float::INFINITY }
if cheapest
  puts "Cheapest chat model by input price:"
  puts "  #{cheapest.id} (#{cheapest.provider}) — $#{cheapest.input_price_per_million}/M tokens"
end
