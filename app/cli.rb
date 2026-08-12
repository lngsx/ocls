# frozen_string_literal: true

require 'thor'

class CLI < Thor
  DEFAULT_LIMIT = 15

  desc 'list [LIMIT]', "List recent opencode sessions (default: #{DEFAULT_LIMIT})"
  def list(limit = DEFAULT_LIMIT)
    limit = limit.to_i
    limit = DEFAULT_LIMIT if limit <= 0

    db = Database.new
    sessions = db.recent_sessions(limit: limit)
    renderer = Renderer.new
    $stdout.print renderer.render(sessions)
  rescue DatabaseNotFoundError => e
    warn e.message
    exit 1
  end

  desc 'version', 'Print ocls version'
  def version
    $stdout.puts "ocls #{VERSION}"
  end

  # Make `list` the default command
  default_task :list

  def self.exit_on_failure?
    true
  end

  # Prepend 'list' when first arg is a number (e.g., `ocls 30`)
  def self.start(original_args = ARGV)
    args = original_args.dup
    args.unshift('list') if args.first&.match?(/\A\d+\z/)
    super(args)
  end
end
