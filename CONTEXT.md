# ocls

A Ruby CLI tool that queries the opencode SQLite database and prints styled recent session listings to the terminal.

## Language

**Session**:
A conversation/work unit in opencode. Has a title, directory, agent, model, token counts, and cost. Stored in the `session` table of the opencode SQLite database.
_Avoid_: conversation, chat, thread

**Agent**:
The AI agent that handled a session. Short string like `H` or `subagents/url-examiner`.
_Avoid_: worker, bot

**Model**:
The AI model used for a session. Stored as JSON with a provider-prefixed ID (e.g., `{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}`). Displayed as the short name after the last `/`.
_Avoid_: engine, backend

**Card**:
A visual block in the terminal output representing one session. Composed of separator, title, agent/model line, tokens/cost line, and location line.
_Avoid_: row, entry, item

**Separator**:
The dim horizontal line (`─`) that divides cards in the output. Exactly 80 characters wide.
_Avoid_: divider, rule

**Tokens**:
Combined input and output token count for a session (`tokens_input + tokens_output`). Displayed with comma formatting.
_Avoid_: usage, count

**Cost**:
Dollar cost of a session, displayed to 4 decimal places (e.g., `$0.0235`).
_Avoid_: price, spend

**Location**:
The project directory where a session took place (e.g., `/home/luang/projects/pacific-rails-6`). The `directory` column in the database.
_Avoid_: path, directory, worktree
