# ocls — Relaxed Spec

## Context

We use opencode daily and accumulate many sessions. There's no quick way to see recent sessions from the terminal — which project they were in, what agent/model was used, token consumption, and cost. We want a proper Ruby CLI tool that prints a styled, readable list of recent sessions, built with full project tooling and conventions.

## Requirements

- It should query the opencode SQLite database (`~/.local/share/opencode/opencode.db`) and print the N most recent sessions.
- It should display these fields per session: title, directory (location), agent, model, tokens, cost.
- It should NOT display timestamps — name/location/agent/model/tokens/cost only.
- It should default to 15 entries when no argument is given.
- It should accept an optional numeric argument to override the limit (e.g., `ocls 30`).
- It should output styled terminal text — bold titles, dimmed locations, colored agent names.
- It should truncate long fields (titles, paths) with `...` to fit within a fixed-width layout (~72-80 cols).
- It should work at 80+ column terminal widths; narrower terminals are out of scope for v1.
- It should use a card-style layout — each session is a visual block with a separator, not a table row.
- It should exit cleanly if the database file doesn't exist, with an error message.

### Deferred (v2+)

- Agent filtering mode (`ocls --main` to exclude subagents).
- Configurable DB path via env var (`OPENCODE_DB`).
- Sorting options (by cost, by tokens).

## Skeleton

### Project Structure

```
ocls/
├── bin/
│   └── ocls                    # Executable entry point
├── lib/
│   ├── ocls.rb                 # Main module, requires
│   └── ocls/
│       ├── cli.rb              # CLI argument parsing (Thor)
│       ├── database.rb         # SQLite3 connection and queries
│       ├── session.rb          # Session model/struct
│       ├── presenter.rb        # Output formatting and styling
│       └── version.rb          # VERSION constant
├── spec/
│   ├── spec_helper.rb          # RSpec config, DB setup
│   ├── ocls/
│   │   ├── cli_spec.rb
│   │   ├── database_spec.rb
│   │   ├── session_spec.rb
│   │   └── presenter_spec.rb
│   └── integration/
│       └── ocls_spec.rb        # End-to-end tests
├── docs/
│   ├── output-design.md        # Visual format specification
│   └── technical-notes.md      # Implementation decisions
├── Gemfile
├── Rakefile
├── ocls.gemspec
├── .rubocop.yml
├── .ruby-version
├── .rspec
├── SPEC.md                     # This file
├── README.md
├── AGENTS.md
├── CHANGELOG.md
└── LICENSE.txt
```

### Core Classes

```ruby
module Ocls
  VERSION = "0.1.0"

  class CLI < Thor
    # ocls [LIMIT]
    # desc "list", "List recent opencode sessions"
    # method_option :limit, type: :numeric, default: 15
  end

  class Database
    # def initialize(db_path = DEFAULT_DB_PATH)
    # def recent_sessions(limit:) -> Array<Session>
  end

  Session = Struct.new(:title, :location, :agent, :model, :tokens, :cost, keyword_init: true)

  class Presenter
    # def initialize(width: 80)
    # def render(sessions) -> String
    # private: truncate, comma_format, card_for
  end
end
```

### Flow

```
bin/ocls
  → Ocls::CLI.start(ARGV)
    → Ocls::Database.new.recent_sessions(limit: n)
      → sqlite3 query → Array<Session>
    → Ocls::Presenter.new.render(sessions)
      → styled card output to stdout
```

## Examples

```
$ ocls
────────────────────────────────────────────────────────────────────────────
  Compare pacific-rails-6 and pacific repositories
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 46,729    Cost: $0.0235
  Location: /home/luang/.local/share/opencode
────────────────────────────────────────────────────────────────────────────
  Project logging system investigation
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 22,126    Cost: $0.0106
  Location: /home/luang/projects/pacific-rails-6

$ ocls 5
(5 entries)
```

## Conventions

- Ruby, full project structure with `lib/`, `bin/`, `spec/`.
- Gems: `sqlite3`, `thor`, `pastel`, `tty-screen`. See `docs/technical-notes.md` for rationale.
- Testing: RSpec. See `spec/` directory.
- Linting: RuboCop with `rubocop-rspec` extension.
- Task runner: Rake (`rake spec`, `rake rubocop`, `rake build`).
- ANSI escape codes via `pastel` gem for styling.
- Use `File.expand_path` for `~` expansion.
- Error messages go to stderr, output goes to stdout.
- See: `docs/output-design.md` for visual format specification.
- See: `docs/technical-notes.md` for implementation constraints.
