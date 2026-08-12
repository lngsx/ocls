# Output Design Specification

## Layout

Each session is rendered as a "card" — a visual block separated by a horizontal rule.

```
────────────────────────────────────────────────────────────────────────────
  <title, truncated to fit>
  Agent: <agent>      Model: <model_short>
  Tokens: <tokens>    Cost: $<cost>
  Location: <directory, truncated to fit>
```

### Field Details

| Field | Source | Formatting | Truncation |
|-------|--------|------------|------------|
| title | `session.title` | Bold cyan (via `pastel`) | Truncate to WIDTH-4 with `...` |
| agent | `session.agent` | Normal | No truncation (short values) |
| model | `json_extract(model, '$.id')` | Normal | Show only part after last `/` (e.g., `openrouter/xiaomi/mimo-v2.5-pro` → `mimo-v2.5-pro`) |
| tokens | `tokens_input + tokens_output` | Comma-formatted number | No truncation |
| cost | `session.cost` | `$X.XXXX` (4 decimal places) | No truncation |
| directory | `session.directory` | Dim (via `pastel`) | Truncate to WIDTH-14 with `...` |

### Separator

- Character: `─` (Unicode box-drawing light horizontal, U+2500)
- Width: exactly WIDTH characters (80 for v1)
- Style: dim (`\e[2m`)

### Spacing

- 2-space indent for all content lines
- No blank line between cards (separator acts as divider)
- One trailing newline after last card

## Width Handling

**Fixed at 80 columns for v1.** This is NOT responsive.

- If a field exceeds its allocated width, truncate with `...` suffix.
- The layout is designed to fit comfortably at 80 cols.
- Narrower terminals will wrap — this is acceptable for v1.
- Future v2 could detect terminal width via `stty size` or `COLUMNS` env var.

## Colors

Use `pastel` gem instead of raw ANSI codes:

```ruby
pastel = Pastel.new
BOLD_CYAN = pastel.bold.cyan   # Title
DIM       = pastel.dim         # Separator, location
```

Keep it minimal — dim separators + cyan titles is enough visual hierarchy.

## Examples at 80 Columns

```
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
────────────────────────────────────────────────────────────────────────────
  Content-Examiner Web Fetching: Reuse or Fork?
  Agent: H          Model: gpt-5.6-terra
  Tokens: 19,159    Cost: $1.8782
  Location: /home/luang/.local/share/opencode
```

## Long Title Truncation

```
────────────────────────────────────────────────────────────────────────────
  Running the project locally and revising it (and the comparison to the s...
  Agent: H          Model: mimo-v2.5-pro
  Tokens: 172,529   Cost: $0.1002
  Location: /home/luang/.local/share/opencode
```

Title was "Running the project locally and revising it (and the comparison to the similar archieved one)" — truncated at 72 chars + `...`.
