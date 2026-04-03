---
type: lesson
title: Audio Transcription
focus: /workspace/beyond_text/transcription.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Audio Transcription

RubyLLM converts speech to text with `RubyLLM.transcribe`. One method call, multiple models, automatic language detection — the same simple API as everything else.

## The Basics

```ruby
result = RubyLLM.transcribe("meeting.mp3")

result.text      # => "Good morning everyone. Today we'll discuss..."
result.model     # => "whisper-1"
result.duration  # => 142.5 (seconds)
```

## Available Models

| Model | Best For |
|-------|---------|
| `whisper-1` | General-purpose transcription (default) |
| `gpt-4o-transcribe` | Technical content, better accuracy |
| `gpt-4o-mini-transcribe` | Fast, cost-effective |
| `gemini-2.5-flash` | Google's multimodal transcription |

## Your Task

Open `transcription.rb` and transcribe an audio file:

1. **Call `RubyLLM.transcribe`** with a file path
2. **Print the transcription** text
3. **Try adding a `language`** hint to improve accuracy on non-English audio
4. **Use a `prompt`** to help the model with domain-specific vocabulary

```ruby title="beyond_text/transcription.rb" ins={4-11}
# Transcribe with the default model
result = RubyLLM.transcribe("recording.mp3")
puts result.text
puts "Duration: #{result.duration}s"
puts

# With options for better accuracy
result = RubyLLM.transcribe(
  "recording.mp3",
  model: "gpt-4o-transcribe",
  language: "en",
  prompt: "Ruby, Rails, ActiveRecord, Gemfile, bundler"
)
puts result.text
```

Run it:

```bash
$ ruby beyond_text/transcription.rb
```

:::note
Requires an OpenAI API key. Audio files must be under 25 MB. Supported formats: MP3, M4A, WAV, WebM, OGG.
:::

## The `prompt` Parameter

The `prompt` is not a question — it's **context** that helps the model recognize specialized vocabulary:

```ruby
# Technical content — prime the model with domain terms
RubyLLM.transcribe("rails_talk.mp3",
  prompt: "Ruby on Rails, ActiveRecord, migrations, Gemfile, Bundler, RSpec, Minitest")

# Medical content
RubyLLM.transcribe("patient_notes.mp3",
  prompt: "hypertension, cardiomyopathy, statin, ACE inhibitor")

# Proper nouns and brand names
RubyLLM.transcribe("interview.mp3",
  prompt: "Anthropic, OpenAI, Gemini, RubyLLM, Sidekiq")
```

Without a prompt, the model may transcribe "RubyLLM" as "Ruby L-L-M" or miss domain vocabulary entirely.

## Speaker Diarization

Some models can identify who is speaking:

```ruby
result = RubyLLM.transcribe(
  "interview.mp3",
  model: "gpt-4o-transcribe-diarize",
  speaker_names: ["Alice", "Bob"]
)

# With timestamps per segment
result.segments.each do |seg|
  puts "[#{seg[:speaker]}] #{seg[:text]}"
end
```

The `segments` array includes `:speaker`, `:text`, `:start`, and `:end` timestamps.

## Language Support

Pass an ISO 639-1 language code for better accuracy with non-English audio:

```ruby
RubyLLM.transcribe("lecture.mp3", language: "es")  # Spanish
RubyLLM.transcribe("call.mp3",    language: "fr")  # French
RubyLLM.transcribe("meeting.mp3", language: "de")  # German
RubyLLM.transcribe("video.mp3",   language: "ja")  # Japanese
```

Without a language hint, the model auto-detects it — but explicit is faster and more accurate.

## Configuration

Set a default model and timeout globally:

```ruby
RubyLLM.configure do |config|
  config.default_transcription_model = "gpt-4o-transcribe"
  config.request_timeout = 600  # 10 minutes for long files
end
```

Long audio files (1+ hours) can take several minutes to process. Increase `request_timeout` accordingly, or split files into smaller chunks.

## Error Handling

```ruby
begin
  result = RubyLLM.transcribe("file.mp3")
  puts result.text
rescue RubyLLM::BadRequestError => e
  puts "File rejected: #{e.message}"
rescue RubyLLM::TimeoutError => e
  puts "Transcription timed out — try a smaller file or increase timeout"
rescue RubyLLM::Error => e
  puts "Transcription failed: #{e.message}"
end
```

## Rails Integration

In a Rails app, transcription fits naturally with Active Storage and background jobs:

```ruby
class TranscriptionJob < ApplicationJob
  def perform(recording_id)
    recording = Recording.find(recording_id)

    # Download the attachment to a temp file
    recording.audio_file.open do |file|
      result = RubyLLM.transcribe(file.path,
        model: "gpt-4o-transcribe",
        prompt: recording.domain_vocabulary)

      recording.update!(
        transcript: result.text,
        duration_seconds: result.duration
      )
    end
  end
end
```
