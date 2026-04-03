#!/usr/bin/env ruby
require "ruby_llm"
require "ruby_llm/schema"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

class ReviewDecision < RubyLLM::Schema
  string :verdict, description: "Either 'pass' or 'revise'"
  string :feedback, description: "Specific, actionable feedback or reason for passing"
  integer :score, description: "Quality score from 1 to 10"
end

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

TOPIC = "How Ruby's `yield` keyword works with blocks"
MAX_ROUNDS = 3

puts "=== Evaluation Loop ==="
puts "Topic: #{TOPIC}"
puts

drafter = DraftAgent.new
critic = CriticAgent.new

# Initial draft
draft = drafter.ask("Write a technical explanation of: #{TOPIC}").content
puts "Round 1 draft:"
puts draft
puts

MAX_ROUNDS.times do |round|
  review = critic.ask("Review this technical explanation:\n\n#{draft}").content

  verdict = review["verdict"]
  score   = review["score"]
  feedback = review["feedback"]

  puts "Review — verdict: #{verdict}, score: #{score}/10"
  puts "Feedback: #{feedback}"
  puts

  break if verdict == "pass"

  # Drafter remembers context — just send the feedback
  draft = drafter.ask("Revise based on this feedback: #{feedback}").content
  puts "Round #{round + 2} draft:"
  puts draft
  puts
end
