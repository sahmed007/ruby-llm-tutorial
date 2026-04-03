#!/usr/bin/env ruby
require "ruby_llm"
require "ruby_llm/schema"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# TODO: Define a schema and use it to extract structured data from text.
#
# A schema is a class that describes the shape of data you want:
#
#   class PersonSchema < RubyLLM::Schema
#     string :name, description: "Person's full name"
#     integer :age, description: "Person's age"
#     string :city, required: false   # optional field
#   end
#
# Use it with a chat:
#   response = chat.with_schema(PersonSchema).ask("Extract from: ...")
#   response.content  # => {"name" => "Alice", "age" => 30}
#
# Available types: string, integer, number (float), boolean, array, object
#
# Define a PersonSchema with: name, age, occupation, city
# Then use it to extract data from the sample text below.

sample_text = "Meet Sarah Chen, a 34-year-old software architect from Portland. " \
              "She specializes in distributed systems and has been coding for 12 years."

puts "=== Structured Output ==="
puts
puts "Input text: #{sample_text}"
puts

# Your code here
