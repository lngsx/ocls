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
git clone <repo-url> ~/.local/share/ocls
cd ~/.local/share/ocls
bundle install
```

## Usage

```bash
# Via binstub
bin/ocls          # Show 15 most recent sessions
bin/ocls 30       # Show 30 most recent sessions

# Via bundle exec
bundle exec ocls
bundle exec ocls 30
```

## Development

```bash
bundle install
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

Personal use. Do whatever you want with it.
