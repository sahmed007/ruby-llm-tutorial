require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  config.request_timeout = 300
end

puts "=== Audio Transcription ==="
puts

# Basic transcription
puts "--- Default model ---"
result = RubyLLM.transcribe("recording.mp3")
puts result.text
puts "Duration: #{result.duration}s | Model: #{result.model}"
puts

# With options for improved accuracy
puts "--- With options ---"
result = RubyLLM.transcribe(
  "recording.mp3",
  model: "gpt-4o-transcribe",
  language: "en",
  prompt: "Ruby, Rails, ActiveRecord, Gemfile, Bundler, RubyLLM"
)
puts result.text
puts "Duration: #{result.duration}s"
puts

# Access per-segment timestamps if available
if result.segments.any?
  puts "--- Segments ---"
  result.segments.first(3).each do |seg|
    puts "[#{seg[:start].round(1)}s] #{seg[:text]}"
  end
end
