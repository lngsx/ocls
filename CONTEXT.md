# ocls

A Ruby CLI tool that queries the opencode SQLite database and prints styled recent session listings to the terminal.

## Language

**Session**:
A conversation/work unit in opencode. Has a title, directory, agent, model, token counts, and cost. Stored in the `session` table of the opencode SQLite database.
_Avoid_: conversation, chat, thread

**Agent**:
The AI agent that handled a session. Short string like `H` or `subagents/url-examiner`. If the agent string contains `/`, the title is suffixed with `(subagent)`; main agents get no suffix.
_Avoid_: worker, bot

**Main agent session**:
A top-level session whose `parent_id` is null. These are the sessions shown by default.
_Avoid_: primary session, root session

**Subagent session**:
A child session whose `parent_id` points to a main agent session. Excluded by default; included with `--all`.
_Avoid_: child session, sub-session

**Subagent**:
An agent identifier containing `/` (e.g., `subagents/url-examiner`). The display heuristic used to append `(subagent)` to the card title. Not equivalent to a subagent session — e.g., `explore` is a subagent session whose identifier has no `/`.

**Model**:
The AI model used for a session. Stored as JSON with a provider-prefixed ID (e.g., `{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}`). Displayed as the short name after the last `/`.
_Avoid_: engine, backend

**Card**:
A visual block in the terminal output representing one session. Composed of separator, title (with optional subagent suffix), location, and model+cost line.
_Avoid_: row, entry, item

**Separator**:
The dim horizontal line (`─`) that divides cards in the output. Exactly 80 characters wide.
_Avoid_: divider, rule

**Tokens**:
Combined input and output token count for a session (`tokens_input + tokens_output`). Displayed with comma formatting in parentheses after cost (e.g., `$0.0024 (15,590)`).
_Avoid_: usage, count

**Cost**:
Dollar cost of a session, displayed to 4 decimal places (e.g., `$0.0024`). Shown on the same line as model, separated by `╍` (U+254D), with tokens in parentheses: `model ▍ $0.0024 (15,590)`.
_Avoid_: price, spend

**Location**:
The project directory where a session took place (e.g., `/home/luang/projects/pacific-rails-6`). The `directory` column in the database. Displayed dimmed without a label.
_Avoid_: path, directory, worktree
