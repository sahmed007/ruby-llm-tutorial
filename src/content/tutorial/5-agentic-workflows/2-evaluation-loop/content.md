---
type: lesson
title: Evaluation Loop
focus: /workspace/agentic_workflows/evaluation_loop.rb
scope: /workspace
custom:
  shell:
    workdir: "/workspace"
---

# Evaluation Loop

A sequential pipeline runs once and delivers results. An **evaluation loop** runs iteratively — a critic reviews the output, and if it doesn't pass, the drafter revises and tries again. The loop continues until quality is met or a maximum number of rounds is reached.

## The Pattern

```
DraftAgent → produces output
     ↓
CriticAgent → reviews it (structured output: pass/revise + feedback)
     ↓
  "pass"? → done
  "revise"? → feed feedback back to DraftAgent → repeat
```

The critic returns **structured output** — a typed hash with `verdict`, `feedback`, and `score`. This makes the loop condition a simple string comparison instead of text parsing.

## Why Structured Output for the Critic?

```ruby
# Without schema — you'd have to parse natural language
review = critic.ask("Review this").content
# => "I think it needs more examples and the explanation is unclear"
# How do you know if it "passed"?

# With schema — predictable, typed data
review = critic.ask("Review this").content
# => { "verdict" => "revise", "feedback" => "Add one example", "score" => 5 }
review["verdict"] == "pass"  # => true/false, reliable
```

## Your Task

Open `evaluation_loop.rb`. `DraftAgent`, `CriticAgent`, and `ReviewDecision` schema are already defined. Your job is to **implement the evaluation loop**:

1. **Ask `DraftAgent`** for an initial draft on `TOPIC`
2. **Pass the draft to `CriticAgent`** for review — it returns structured output
3. **Check the verdict**: if `"revise"`, send the feedback back to `DraftAgent` for a revision
4. **Loop** up to `MAX_ROUNDS` times
5. **Print each round** showing the draft, verdict, score, and feedback

```ruby title="agentic_workflows/evaluation_loop.rb" ins={4-24}
MAX_ROUNDS = 3

drafter = DraftAgent.new
critic = CriticAgent.new

# Initial draft
draft = drafter.ask("Write an explanation of: #{TOPIC}").content
puts "Round 1 draft:\n#{draft}\n"

MAX_ROUNDS.times do |round|
  review = critic.ask("Review this technical explanation:\n\n#{draft}").content

  puts "Review — verdict: #{review["verdict"]}, score: #{review["score"]}/10"
  puts "Feedback: #{review["feedback"]}"
  puts

  break if review["verdict"] == "pass"

  # Ask the drafter to revise — it remembers the original draft
  draft = drafter.ask(
    "Please revise based on this feedback: #{review["feedback"]}"
  ).content
  puts "Round #{round + 2} draft:\n#{draft}\n"
end
```

Run it:

```bash
$ ruby agentic_workflows/evaluation_loop.rb
```

Watch the draft improve across rounds as the critic's feedback is incorporated.

:::tip
Notice that `drafter` is a single instance — its conversation history accumulates. Each revision request builds on the previous draft without you re-sending the full text.
:::

## Why Not Just Run It Once?

A single pass gives you whatever quality the model generates on the first try. The evaluation loop gives you **consistent minimum quality**:

- Set your bar: "score >= 7 and includes a code example"
- The loop guarantees you never ship below that bar
- Usually 1-2 revisions are enough; rarely need 3+

## Convergence and Limits

Always set a `MAX_ROUNDS`. Without it, a disagreeable critic could loop forever:

```ruby
MAX_ROUNDS = 3  # Cost and time bounded
rounds_taken = 0

loop do
  break if review["verdict"] == "pass" || rounds_taken >= MAX_ROUNDS
  # ...
  rounds_taken += 1
end

if rounds_taken >= MAX_ROUNDS
  puts "Warning: max rounds reached — using best available draft"
end
```

## Adjusting the Quality Bar

Change what "pass" means by updating the critic's instructions:

```ruby
class CriticAgent < RubyLLM::Agent
  instructions <<~PROMPT
    Return "pass" if ALL of these are true:
    1. Technically accurate
    2. Includes a working code example
    3. Under 200 words
    4. Score >= 8
    Otherwise return "revise" with specific, actionable feedback.
  PROMPT
end
```

Tighter criteria → more revisions → higher quality → higher cost. Tune based on your use case.
