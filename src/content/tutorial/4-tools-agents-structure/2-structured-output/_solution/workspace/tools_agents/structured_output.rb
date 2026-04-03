require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

class PersonSchema < RubyLLM::Schema
  string :name, description: "Person's full name"
  integer :age, description: "Person's age in years"
  string :occupation, description: "What they do for work"
  string :city, description: "Where they live"
end

sample_text = "Meet Sarah Chen, a 34-year-old software architect from Portland. " \
              "She specializes in distributed systems and has been coding for 12 years."

puts "=== Structured Output ==="
puts
puts "Input text: #{sample_text}"
puts

chat = RubyLLM.chat
response = chat.with_schema(PersonSchema)
               .ask("Extract the person's information from this text: #{sample_text}")

puts "Extracted data:"
response.content.each do |key, value|
  puts "  %-12s %s" % [key + ":", value]
end
