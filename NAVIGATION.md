# NAVIGATION.md
# Project navigation and file map for agent orientation.
# Format: YAML with usage instructions as header comments.

# ── How to use this file ──
# Before reading a file, check its entry here. The annotations often answer
# your question without opening the file.
#
# Each file entry is a four-item sequence:
# [path, description, token_density, annotations]
#
# - path, description, token_density: mandatory positional prefix, in that order.
# - annotations: fourth item, a keyed mapping. purpose is required.
# - token_density: light = safe to read directly. dense = use content-examiner or read selectively.
# - purpose: why the file exists. Use this to decide if it's relevant.
# - key_concepts: what you'd learn by reading it. Use this to orient without reading.
# - key_exports: what it exposes — interfaces, commands, outputs.
# - reads_from: dependencies. Use this to trace relationships.

files:
  - - bin/ocls
    - Executable entry point
    - light
    - purpose: Shebang script that boots the CLI. Only file that runs directly.
      key_concepts:
        - ARGV passthrough to Thor
      reads_from:
        - lib/ocls.rb

  - - lib/ocls.rb
    - Main module, requires all components
    - light
    - purpose: Single require point. Loads version, session, database, presenter, cli in order.
      key_concepts:
        - require_relative load order
      key_exports:
        - Ocls module

  - - lib/ocls/cli.rb
    - Thor CLI with list and version commands
    - light
    - purpose: Defines the user-facing command interface. Handles argument parsing and orchestration.
      key_concepts:
        - Thor subclass with default_task
        - Numeric arg detection (ocls 30 → list 30)
        - exit_on_failure? for clean error exits
      key_exports:
        - Ocls::CLI.start(ARGV)
        - list [LIMIT] command (default 15)
        - version command
      reads_from:
        - lib/ocls/database.rb
        - lib/ocls/presenter.rb

  - - lib/ocls/database.rb
    - SQLite3 query layer against opencode DB
    - light
    - purpose: Opens the opencode database, runs the session query, maps rows to Session structs.
      key_concepts:
        - DEFAULT_DB_PATH (~/.local/share/opencode/opencode.db)
        - JSON extraction for model field
        - DatabaseNotFoundError for missing DB
        - Edge cases: nil model → "unknown", empty title → "(untitled)"
      key_exports:
        - Ocls::Database.new(db_path?).recent_sessions(limit:)
        - Ocls::DatabaseNotFoundError
      reads_from:
        - lib/ocls/session.rb

  - - lib/ocls/presenter.rb
    - Card-style styled terminal output
    - light
    - purpose: Renders Session structs as styled terminal cards with dim separators, bold cyan titles, comma-formatted tokens.
      key_concepts:
        - Fixed 80-col width (DEFAULT_WIDTH)
        - Unicode separator (U+2500)
        - pastel gem for styling (bold.cyan, dim)
        - Truncation with "..." for long titles/paths
        - Comma formatting for token counts
      key_exports:
        - Ocls::Presenter.new(width?, pastel?).render(sessions)
      reads_from:
        - lib/ocls/session.rb

  - - lib/ocls/session.rb
    - Session data struct
    - light
    - purpose: Defines the Session struct used throughout the app. Pure data, no behavior.
      key_concepts:
        - keyword_init Struct
      key_exports:
        - Ocls::Session (title, location, agent, model, tokens, cost)

  - - lib/ocls/version.rb
    - VERSION constant
    - light
    - purpose: Single source of truth for the version string, used by gemspec and CLI.
      key_exports:
        - Ocls::VERSION

  - - spec/spec_helper.rb
    - RSpec configuration and test helpers
    - light
    - purpose: Sets up a temporary SQLite test DB, provides helpers for inserting test sessions, cleans up between tests.
      key_concepts:
        - Temporary test DB in /tmp (per PID)
        - Schema mirrors opencode session table
        - insert_test_session helper with defaults
        - before(:suite) create, before(:each) clear, after(:suite) delete
      key_exports:
        - test_db_path helper
        - insert_test_session(db_path, attrs) helper

  - - spec/ocls/database_spec.rb
    - Database layer tests
    - light
    - purpose: Verifies query ordering, limit, model JSON extraction, nil model, empty title, missing DB error.
      reads_from:
        - lib/ocls/database.rb
        - spec/spec_helper.rb

  - - spec/ocls/presenter_spec.rb
    - Presenter output tests
    - light
    - purpose: Verifies card rendering, separator format, comma formatting, truncation, cost format, empty input.
      reads_from:
        - lib/ocls/presenter.rb
        - spec/spec_helper.rb

  - - spec/ocls/cli_spec.rb
    - CLI command tests
    - light
    - purpose: Verifies list output, limit argument, version output, missing DB error handling.
      reads_from:
        - lib/ocls/cli.rb
        - spec/spec_helper.rb

  - - spec/ocls/session_spec.rb
    - Session struct tests
    - light
    - purpose: Verifies struct attributes and keyword_init support.
      reads_from:
        - lib/ocls/session.rb

  - - spec/integration/ocls_spec.rb
    - End-to-end integration tests
    - light
    - purpose: Verifies full flow from DB query through styled output, matching the spec format.
      reads_from:
        - lib/ocls/database.rb
        - lib/ocls/presenter.rb
        - lib/ocls/cli.rb
        - spec/spec_helper.rb

  - - ocls.gemspec
    - Gem specification
    - light
    - purpose: Declares gem metadata, dependencies (sqlite3, thor, pastel, tty-screen), and dev dependencies (rspec, rubocop).
      key_concepts:
        - Runtime deps: sqlite3, thor, pastel, tty-screen
        - Dev deps: rake, rspec, rubocop, rubocop-rspec

  - - Gemfile
    - Bundler dependency file
    - light
    - purpose: Points to gemspec for all dependencies.
      reads_from:
        - ocls.gemspec

  - - Rakefile
    - Task runner configuration
    - light
    - purpose: Defines rake tasks. Default task runs spec + rubocop.
      key_concepts:
        - RSpec::Core::RakeTask
        - RuboCop::RakeTask
        - default task = spec + rubocop

  - - .rubocop.yml
    - RuboCop linting configuration
    - light
    - purpose: Configures RuboCop cops. Relaxes some RSpec cops for test readability.
      key_concepts:
        - plugins: rubocop-rspec
        - Relaxed ExampleLength (20), MultipleExpectations (15)
        - DescribeClass excluded for integration specs

  - - AGENTS.md
    - AI coworking guide
    - light
    - purpose: Orientation document for AI agents. Describes architecture, scope boundaries, how to work.
      key_concepts:
        - Architecture overview
        - Scope boundaries (in/out)
        - Deferred v2+ features
