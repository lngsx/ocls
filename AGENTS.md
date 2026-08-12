# AGENTS.md — AI Coworking Guide

## Project Goal

`ocls` is a Ruby CLI tool that queries the opencode SQLite database and prints styled recent session listings to the terminal. It's built with full Ruby project conventions — Bundler, Rake, RSpec, RuboCop, proper gem structure. The goal is a maintainable, well-structured project that follows Ruby community standards.

## What You're Here To Do

Pick up where the last session left off. The spec (`SPEC.md`) and supporting docs (`docs/`) contain all the design decisions already made. Your job is to **implement** the project and verify it works.

## Scope Boundaries

### In Scope
- Implementing the full project structure (`lib/`, `bin/`, `spec/`)
- Setting up Gemfile, gemspec, Rakefile, RuboCop config
- Implementing core classes: Database, Session, Presenter, CLI
- Writing RSpec tests for each component
- Styling terminal output with `pastel` gem
- Querying SQLite3 via `sqlite3` gem
- Handling edge cases (missing DB, empty results, long strings)
- Testing against the real opencode database

### Out of Scope
- Building a distributable gem (no `gem build`/`gem push` workflow)
- Network features
- GUI anything
- Refactoring opencode itself

## Key Decisions Already Made

1. **Ruby** — the implementation language.
2. **Full project structure** — `lib/`, `bin/`, `spec/`, Gemfile, gemspec, Rakefile. Not a single-file script.
3. **Gems: sqlite3, thor, pastel, tty-screen** — see `docs/technical-notes.md` for why each was chosen.
4. **RSpec** for testing, **RuboCop** for linting.
5. **Fixed width (80 cols)** — not truly responsive. Truncate long fields with `...`.
6. **Card-style output** — each session is a visual block with a dim separator line, not a table row. Tables are not responsive to terminal width by nature.

## How to Work

1. Read `SPEC.md` first — it has the full requirements, project structure, and class skeleton.
2. Read `docs/output-design.md` — it has the exact visual format.
3. Read `docs/technical-notes.md` — it has gem choices, implementation constraints, and gotchas.
4. Set up the project skeleton: Gemfile, gemspec, Rakefile, directory structure.
5. Implement core classes in `lib/ocls/`.
6. Write RSpec tests in `spec/`.
7. Run `bundle exec rake` to verify everything passes.
8. Test against the real DB at `~/.local/share/opencode/opencode.db`.

## What NOT to Do

- Don't add features beyond what SPEC.md describes (see "Deferred" section for v2 ideas).
- Don't refactor or improve the database schema.
- Don't skip tests — this project uses RSpec properly.
- Don't use raw ANSI codes when `pastel` handles it cleanly.

## Questions to Ask the User

If anything in SPEC.md is ambiguous, ask before implementing. Prefer asking over guessing. The user is the domain expert on their own workflow and preferences.
