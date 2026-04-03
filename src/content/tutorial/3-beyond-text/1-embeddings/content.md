---
type: lesson
title: Embeddings
focus: /workspace/beyond_text/embeddings.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Embeddings

Embeddings convert text into arrays of numbers (vectors) where **similar meanings produce similar vectors**. This is the technology behind semantic search, recommendations, and RAG.

## One Line of Code

```ruby
embedding = RubyLLM.embed("Ruby is a programmer's best friend")

embedding.vectors        # => [0.0231, -0.0142, ...] (1536 floats)
embedding.model          # => "text-embedding-3-small"
embedding.input_tokens   # => 8
```

## Why Embeddings Matter

Traditional search matches **keywords**. Embedding search matches **meaning**:

| Query | Keyword match | Embedding match |
|-------|--------------|-----------------|
| "Ruby programming" | Only "Ruby programming" | Also "Rails development", "writing Ruby code" |
| "happy" | Only "happy" | Also "joyful", "delighted", "pleased" |

## Your Task

Open `embeddings.rb`. Three sample texts and a cosine similarity helper are provided. Your job:

1. **Generate embeddings** for each text with `RubyLLM.embed`
2. **Extract vectors** from the results
3. **Compare pairs** using the `cosine_similarity` helper
4. **Print the scores** to see which texts are most similar

```ruby title="embeddings.rb"
vectors = texts.map do |text|
  embedding = RubyLLM.embed(text)
  embedding.vectors
end

# Compare pairs
score = cosine_similarity(vectors[0], vectors[1])
puts "Ruby vs Python: #{score}"
```

Run it:

```bash
$ ruby embeddings.rb
```

You should see that the two programming texts have a higher similarity score than either compared to the weather text.

## Batch Embeddings

Embed multiple texts in a single API call:

```ruby
result = RubyLLM.embed(["Ruby", "Python", "JavaScript"])

result.vectors.length  # => 3
result.vectors[0]      # => vector for "Ruby"
```

## Choosing Models

```ruby
RubyLLM.embed("text", model: "text-embedding-3-large")   # higher dimensions
RubyLLM.embed("text", model: "text-embedding-004")       # Google
RubyLLM.embed("text", dimensions: 512)                   # reduced dimensions
```

## Real-World Use Cases

- **Semantic search** — find documents by meaning, not keywords
- **Recommendations** — similar content or user preferences
- **RAG** — retrieve relevant context for AI prompts
- **Clustering** — group similar documents automatically
- **Deduplication** — find near-duplicate content
