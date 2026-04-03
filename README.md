# RubyLLM Tutorial

An interactive, browser-based tutorial for [RubyLLM](https://rubyllm.com/) — the elegant Ruby interface for AI. Runs entirely in the browser via WebAssembly; no backend required.

Built by [Chamoy Labs](https://chamoylabs.com) based on RubyLLM by [Carmine Paolino](https://paolino.me/). Powered by [TutorialKit](https://github.com/Bakaface/tutorialkit.rb).

## What’s Covered

- **Introduction** — What RubyLLM is and how it works
- **Chat** — Basic chat, multi-turn conversations, multimodal input
- **Beyond Text** — Working with embeddings and other non-chat features
- **Tools, Agents & Structure** — Giving models tools to call, structuring outputs
- **Agentic Workflows** — Sequential pipelines and evaluation loops
- **Conclusion** — Next steps and resources

## Project Structure

```
src/content/tutorial/   # Tutorial lessons (parts, chapters, content.md)
src/templates/          # WebContainer file templates (base app states)
ruby-wasm/Gemfile       # Gems compiled into the WASM binary
ruby-wasm/              # WASM build pipeline
```

## Development

```bash
npm install
npm run dev             # http://localhost:4321/
```

## Modifying the Tutorial

Lessons live in `src/content/tutorial/` as `content.md` files alongside `_files/` (starter files) and `_solution/` (solution files). Each directory level has a `meta.md` with frontmatter configuration.

To add gems, edit `ruby-wasm/Gemfile` then rebuild the WASM binary:

```bash
bin/build-wasm
```

See `CLAUDE.md` for full authoring guidance.
