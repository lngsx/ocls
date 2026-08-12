# ocls

ls opencode sessions across all projects, not directory-scoped like the built-in session list.

## What it does

Queries the opencode SQLite database and prints a styled, card-style list of recent sessions showing:

- Session title
- Agent and model used
- Token count and cost
- Project directory

## Setup

```bash
cd /path/to/ocls
bundle install
```

## Usage

```bash
bin/ocls          # Show 15 most recent sessions
bin/ocls 30       # Show 30 most recent sessions
bin/ocls version  # Print version
```

## Development

```bash
bundle exec rake        # Run tests + linting
bundle exec rspec       # Tests only
bundle exec rubocop     # Linting only
```

## Example Output

```
────────────────────────────────────────────────────────────────────────────
  Compare pacific-rails-6 and pacific repositories
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 46,729    Cost: $0.0235
  Location: /home/luang/projects/pacific-rails-6
────────────────────────────────────────────────────────────────────────────
  Project logging system investigation
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 22,126    Cost: $0.0106
  Location: /home/luang/projects/pacific-rails-6
```

## License

MIT
