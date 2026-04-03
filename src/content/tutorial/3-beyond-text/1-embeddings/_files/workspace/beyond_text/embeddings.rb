#!/usr/bin/env ruby
require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Generate embeddings and compare text similarity.
#
# Embeddings convert text into arrays of numbers (vectors).
# Similar meanings produce similar vectors.
#
#   embedding = RubyLLM.embed("some text")
#   embedding.vectors       — array of floats (e.g., 1536 dimensions)
#   embedding.model         — which model was used
#   embedding.input_tokens  — tokens consumed
#
# Steps:
#   1. Generate embeddings for each text below
#   2. Extract the vector from each: embedding.vectors
#   3. Calculate cosine similarity between pairs
#   4. Print which texts are most similar

texts = [
  "Ruby is a dynamic programming language focused on simplicity",
  "Python is a versatile language popular in data science",
  "The weather today is sunny with a high of 75 degrees"
]

# Helper: cosine similarity between two vectors
def cosine_similarity(vec_a, vec_b)
  dot = vec_a.zip(vec_b).sum { |a, b| a * b }
  mag_a = Math.sqrt(vec_a.sum { |a| a**2 })
  mag_b = Math.sqrt(vec_b.sum { |b| b**2 })
  return 0.0 if mag_a.zero? || mag_b.zero?
  (dot / (mag_a * mag_b)).round(4)
end

puts "=== Embedding Similarity ==="
puts
# Your code here
