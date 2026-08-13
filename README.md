
<p align="center">
  <img width="400" height="503" alt="Image" src="https://github.com/user-attachments/assets/0b7739db-930f-4b00-9980-820e1c843347" />
</p>

# ocls

`ls` opencode sessions across all projects, not directory-scoped like the built-in session list.

## Why

I sometimes work across multiple projects and directories in opencode, and when I do,I often lose track of where I started a session. There's no built-in or plugin way to see sessions across all projects in one place. `ocls` is a simple SQL query executor against the opencode SQLite database that prints the results in a readable format.

## What it does

Queries the opencode SQLite database and prints a styled, card-style list of recent sessions showing:

- Session title
- Agent and model used
- Token count and cost
- Project directory

Subagent sessions (child sessions with a `parent_id`) are excluded by default; pass `--all` to include them.

## Setup

```bash
bundle install
```

## Usage

```bash
bin/ocls           # Show 15 most recent main-agent sessions
bin/ocls 30        # Show 30 most recent main-agent sessions
bin/ocls --all     # Include subagent sessions
bin/ocls 30 --all  # Show 30 sessions, including subagents
```

Example output:

```
────────────────────────────────────────────────────────────────────────────────
  Compare pacific-rails-6 and pacific repositories
  /home/whatever/projects/pacific-rails-6
  mimo-v2.5-pro ╍ $0.0235 (46,729)
────────────────────────────────────────────────────────────────────────────────
  Project logging system investigation
  /home/whatever/projects/pacific-rails-6
  mimo-v2.5-pro ╍ $0.0106 (22,126)
────────────────────────────────────────────────────────────────────────────────
```

## Development

```bash
bundle exec rake        # Run tests + linting
bundle exec rspec       # Tests only
bundle exec rubocop     # Linting only
```

## License

MIT
