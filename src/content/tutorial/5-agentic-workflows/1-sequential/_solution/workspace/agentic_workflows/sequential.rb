require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

class ResearchAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.2
  instructions <<~PROMPT
    You are a research assistant specializing in Ruby and programming topics.
    When given a topic, provide:
    - 4-6 key facts or concepts
    - Important context a developer should know
    - One concrete, illustrative example
    Be precise and factual. Keep your response under 200 words.
  PROMPT
end

class WriterAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.7
  instructions <<~PROMPT
    You are a technical writer for a developer blog.
    You receive research notes and transform them into a clear,
    engaging 2-paragraph blog-style explanation.
    Use an approachable, conversational tone. Assume a developer audience.
  PROMPT
end

TOPIC = "Ruby's object model and why everything is an object"

puts "=== Sequential Workflow ==="
puts "Topic: #{TOPIC}"
puts

# Phase 1: Research
puts "--- Phase 1: Research ---"
researcher = ResearchAgent.new
research = researcher.ask("Research this topic thoroughly: #{TOPIC}")
puts research.content
puts "(#{research.input_tokens} input / #{research.output_tokens} output tokens)"
puts

# Phase 2: Writing
puts "--- Phase 2: Writing ---"
writer = WriterAgent.new
article = writer.ask(
  "Transform these research notes into a concise 2-paragraph developer blog post:\n\n#{research.content}"
)
puts article.content
puts
