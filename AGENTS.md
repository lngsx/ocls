# AGENTS.md — AI Coworking Guide

## Project Goal

`ocls` is a Ruby CLI tool that queries the opencode SQLite database and prints styled recent session listings to the terminal. It's built with full Ruby project conventions — Bundler, Rake, RSpec, RuboCop, proper gem structure.

## What You're Here To Do

The project is implemented and working. Your job is to maintain it, fix bugs, and add features as requested. When in doubt, ask the user.

## Architecture

- `bin/ocls` — executable entry point
- `app/cli.rb` — Thor CLI, handles `list [LIMIT]` and `version` commands
- `app/database.rb` — SQLite3 query layer against `~/.local/share/opencode/opencode.db`
- `app/renderer.rb` — card-style styled terminal output (80 cols, pastel gem)
- `app/structs.rb` — Session struct (title, location, agent, model, tokens, cost)
- `version.rb` — VERSION constant
- `lib/ocls.rb` — thin loader, requires from app/

## Scope Boundaries

### In Scope
- Bug fixes and edge case handling
- Adding features the user requests
- Improving test coverage
- Maintaining Ruby project conventions

### Out of Scope
- Building a distributable gem (no `gem build`/`gem push` workflow)
- Network features
- GUI anything
- Refactoring opencode itself

## Key Decisions

1. **Ruby** with `app/` based structure (Rails-inspired)
2. **Gems:** sqlite3, thor, pastel
3. **RSpec** for testing, **RuboCop** for linting
4. **Fixed 80-col width** — not responsive, truncates with `...`
5. **Card-style output** — dim separator lines, bold cyan titles, 4-line cards (separator, title, location, model+cost)
6. **Flat specs** — all specs in `spec/` root, no subdirectories
7. **Main-agent-only by default** — `ocls list` shows only sessions with `parent_id IS NULL`; `--all` includes subagent sessions

## How to Work

1. Run `bundle exec rake` to verify tests + linting pass before and after changes.
2. Test against the real DB at `~/.local/share/opencode/opencode.db` when touching Database or Renderer.
3. Don't skip tests — this project uses RSpec properly.
4. Don't use raw ANSI codes when `pastel` handles it cleanly.

## Deferred (v2+)

- Configurable DB path via env var (`OPENCODE_DB`)
- Sorting options (by cost, by tokens)
