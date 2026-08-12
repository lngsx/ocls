
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

## Setup

```bash
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
  Location: /home/whatever/projects/pacific-rails-6
────────────────────────────────────────────────────────────────────────────
  Project logging system investigation
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 22,126    Cost: $0.0106
  Location: /home/whatever/projects/pacific-rails-6
```

## License

MIT
