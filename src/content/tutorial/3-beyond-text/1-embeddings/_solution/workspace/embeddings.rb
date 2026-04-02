require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

texts = [
  "Ruby is a dynamic programming language focused on simplicity",
  "Python is a versatile language popular in data science",
  "The weather today is sunny with a high of 75 degrees"
]

def cosine_similarity(vec_a, vec_b)
  dot = vec_a.zip(vec_b).sum { |a, b| a * b }
  mag_a = Math.sqrt(vec_a.sum { |a| a**2 })
  mag_b = Math.sqrt(vec_b.sum { |b| b**2 })
  return 0.0 if mag_a.zero? || mag_b.zero?
  (dot / (mag_a * mag_b)).round(4)
end

puts "=== Embedding Similarity ==="
puts

# Generate embeddings for all texts
vectors = texts.map do |text|
  puts "Embedding: #{text[0..50]}..."
  embedding = RubyLLM.embed(text)
  embedding.vectors
end

puts
puts "Vector dimensions: #{vectors.first.length}"
puts

# Compare all pairs
pairs = [
  [0, 1, "Ruby vs Python (both programming)"],
  [0, 2, "Ruby vs Weather (different topics)"],
  [1, 2, "Python vs Weather (different topics)"]
]

puts "Similarity Scores:"
puts "-" * 50
pairs.each do |i, j, label|
  score = cosine_similarity(vectors[i], vectors[j])
  bar = "#" * (score * 40).to_i
  puts "  %-40s %.4f %s" % [label, score, bar]
end
