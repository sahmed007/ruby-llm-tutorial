require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", nil)
end

# A sample quarterly report is provided at: chat/report.txt
#
# TODO: Ask the AI to analyze the document.
#
# Attach files to any message using the `with:` keyword:
#
#   response = chat.ask("Summarize this", with: "chat/report.txt")
#
# After the first message with the attachment, the document
# lives in the conversation history — follow-up questions
# don't need `with:` again.
#
# Steps:
#   1. Create a chat and ask for a 3-bullet summary of report.txt
#   2. Print the response and its input token count
#   3. Ask a follow-up question about a specific product line

puts "=== Multi-Modal Chat ==="
puts

chat = RubyLLM.chat
# Your code here
