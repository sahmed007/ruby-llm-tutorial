#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# --- Structured output schema for the critic ---
class ReviewDecision < RubyLLM::Schema
  string :verdict, description: "Either 'pass' or 'revise'"
  string :feedback, description: "Specific, actionable feedback or reason for passing"
  integer :score, description: "Quality score from 1 to 10"
end

# --- Agents ---

class DraftAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.7
  instructions <<~PROMPT
    You write concise technical explanations for Ruby developers.
    Target: clear, accurate, under 150 words, with one code example.
    When given revision feedback, incorporate it into an improved draft.
  PROMPT
end

class CriticAgent < RubyLLM::Agent
  model "gpt-4o"
  temperature 0.1
  schema ReviewDecision
  instructions <<~PROMPT
    You review technical Ruby explanations against these criteria:
    1. Accuracy  — is it technically correct?
    2. Clarity   — would a developer new to the topic understand it?
    3. Brevity   — is it under 150 words?
    4. Example   — does it include a working code snippet?
    Return "pass" if score >= 7. Otherwise return "revise" with
    specific, actionable feedback on what to improve.
  PROMPT
end

# TODO: Implement the evaluation loop.
#
# Pattern:
#   1. DraftAgent writes an initial explanation of TOPIC
#   2. CriticAgent reviews it (returns ReviewDecision schema)
#      — review["verdict"] is "pass" or "revise"
#      — review["score"] is 1-10
#      — review["feedback"] is specific guidance
#   3. If verdict is "revise", ask DraftAgent to revise using the feedback
#      (DraftAgent remembers context — just send the feedback, not the full draft)
#   4. Repeat up to MAX_ROUNDS times
#   5. Print progress each round
#
# Key insight: drafter is one instance, so its conversation
# accumulates — each revision builds naturally on the previous.

TOPIC = "How Ruby's `yield` keyword works with blocks"
MAX_ROUNDS = 3

puts "=== Evaluation Loop ==="
puts "Topic: #{TOPIC}"
puts

drafter = DraftAgent.new
critic = CriticAgent.new

# Your evaluation loop here
