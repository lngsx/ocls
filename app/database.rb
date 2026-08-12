# frozen_string_literal: true

require 'json'
require 'sqlite3'

class Database
  DEFAULT_DB_PATH = '~/.local/share/opencode/opencode.db'

  def initialize(db_path = DEFAULT_DB_PATH)
    @db_path = File.expand_path(db_path)
  end

  def recent_sessions(limit: 15)
    db = SQLite3::Database.new(@db_path)
    db.results_as_hash = true

    rows = db.execute(SQL, [limit])
    rows.map { |row| build_session(row) }
  rescue SQLite3::CantOpenException
    raise DatabaseNotFoundError, "Database not found: #{@db_path}"
  ensure
    db&.close
  end

  private

  SQL = <<~SQL
    SELECT
      title,
      directory,
      agent,
      model,
      tokens_input + tokens_output AS tokens,
      cost
    FROM session
    ORDER BY time_created DESC
    LIMIT ?
  SQL

  def build_session(row)
    model_id = extract_model_id(row['model'])
    model_short = model_id&.split('/')&.last || 'unknown'

    Session.new(
      title: row['title'].to_s.empty? ? '(untitled)' : row['title'],
      location: row['directory'],
      agent: row['agent'] || 'unknown',
      model: model_short,
      tokens: row['tokens'].to_i,
      cost: row['cost'].to_f
    )
  end

  def extract_model_id(model_json)
    return nil if model_json.nil? || model_json.to_s.empty?

    parsed = JSON.parse(model_json)
    parsed['id']
  rescue JSON::ParserError
    nil
  end
end

class DatabaseNotFoundError < StandardError; end # rubocop:disable Style/OneClassPerFile
