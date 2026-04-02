require "ruby_llm"

RubyLLM.configure do |config|
  # Add your API keys here — only configure the providers you plan to use
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
  config.anthropic_api_key = ENV.fetch("ANTHROPIC_API_KEY", nil)
  config.gemini_api_key = ENV.fetch("GEMINI_API_KEY", nil)
end
