require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  config.request_timeout = 300  # 5 minutes — audio files can be slow
end

# TODO: Transcribe an audio file.
#
# Basic usage:
#   result = RubyLLM.transcribe("path/to/file.mp3")
#   puts result.text
#   puts result.duration
#
# With options:
#   result = RubyLLM.transcribe(
#     "recording.mp3",
#     model: "gpt-4o-transcribe",   # better accuracy
#     language: "en",               # ISO 639-1 code
#     prompt: "Ruby, Rails, Gemfile" # help with domain vocabulary
#   )
#
# Supported formats: MP3, M4A, WAV, WebM, OGG (max 25 MB)
#
# Response properties:
#   result.text     — full transcription text
#   result.model    — model used
#   result.duration — audio length in seconds
#   result.segments — per-segment with timestamps (when available)
#
# Steps:
#   1. Transcribe a file with the default model
#   2. Print the text and duration
#   3. Try with model: "gpt-4o-transcribe" and a prompt for better accuracy

puts "=== Audio Transcription ==="
puts

# Your code here
