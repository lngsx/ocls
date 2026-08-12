# Technical Notes

## Gem Choices

### sqlite3

**Why:** Native Ruby binding to SQLite. Proper type handling, prepared statements, no string parsing.

```ruby
db = SQLite3::Database.new(File.expand_path("~/.local/share/opencode/opencode.db"))
db.results_as_hash = true
rows = db.execute(sql, [limit])
```

Alternative considered: shelling out to `sqlite3` CLI and parsing column output. Rejected — fragile, requires parsing fixed-width output or tab-separated values.

### thor

**Why:** Standard Ruby CLI framework. Handles argument parsing, help text, subcommands. Used by Rails generators, Homebrew, Vagrant.

```ruby
class CLI < Thor
  desc "list", "List recent sessions"
  method_option :limit, type: :numeric, default: 15
  def list(limit = options[:limit])
    # ...
  end
end
```

Alternative considered: `optparse` (stdlib). Works but more boilerplate, no help generation.

### pastel

**Why:** Clean API for terminal colors and styles. Part of the TTY toolkit (same author as tty-screen). No raw ANSI codes.

```ruby
pastel = Pastel.new
pastel.bold.cyan("title")   # instead of "\e[1;36mtitle\e[0m"
pastel.dim("separator")     # instead of "\e[2mseparator\e[0m"
```

Alternative considered: `colorize` gem. More popular but monkey-patches String, which is contentious.

### tty-screen

**Why:** Terminal width detection. Part of TTY toolkit. Works cross-platform.

```ruby
width = TTY::Screen.width  # => 120
```

Alternative considered: `stty size` or `COLUMNS` env var. Less reliable, platform-dependent.

## Model Field

The `model` column stores JSON: `{"id":"xiaomi/mimo-v2.5-pro","providerID":"openrouter"}`.

Extract the short name with SQL:
```sql
json_extract(model, '$.id')
```

Then further shorten by taking the part after the last `/`:
```ruby
model_short = model_id.split("/").last  # "mimo-v2.5-pro"
```

## Number Formatting

Insert commas in numbers (1234567 → 1,234,567):

```ruby
def comma_format(n)
  n.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end
```

## Edge Cases

| Case | Handling |
|------|----------|
| DB file missing | Print error to stderr, exit 1 |
| Empty result set | Print nothing (no separator, no cards) |
| Title is empty string | Show `(untitled)` |
| Model JSON is null | Show `unknown` |
| Very long path (>70 chars) | Truncate with `...` |
| 0 rows returned | Silent exit, no output |

## Rake Tasks

```bash
rake spec       # Run RSpec tests
rake rubocop    # Run RuboCop linting
rake build      # Build gem (if needed later)
rake default    # spec + rubocop (what `rake` runs)
```

## File Structure

```
bin/ocls           # Executable entry point
lib/ocls.rb        # Main module
lib/ocls/          # Core classes
spec/              # RSpec tests
Gemfile            # Dependencies
Rakefile           # Task runner
ocls.gemspec       # Gem specification
.rubocop.yml       # Linting config
```
