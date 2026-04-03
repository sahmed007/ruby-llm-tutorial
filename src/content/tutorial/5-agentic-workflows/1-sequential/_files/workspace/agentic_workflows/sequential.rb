require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# --- Agents ---
# Each agent has a single, focused responsibility.

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

# TODO: Implement a sequential content pipeline.
#
# A sequential workflow is just Ruby:
# output from one agent becomes input to the next.
#
# Steps:
#   1. Instantiate ResearchAgent and ask it to research TOPIC
#   2. Print its output (the research notes)
#   3. Instantiate WriterAgent and ask it to write a blog post
#      from the research notes — pass research.content in your message
#   4. Print the final article
#
# Key pattern:
#   researcher = ResearchAgent.new
#   research = researcher.ask("Research: #{TOPIC}")
#
#   writer = WriterAgent.new
#   article = writer.ask("Write from these notes:\n\n#{research.content}")

TOPIC = "Ruby's object model and why everything is an object"

puts "=== Sequential Workflow ==="
puts "Topic: #{TOPIC}"
puts

# Your workflow here
