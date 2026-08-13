# frozen_string_literal: true

require 'ocls'
require 'tmpdir'
require 'fileutils'
require 'securerandom'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed

  # Create a temporary test database for integration tests
  config.before(:suite) do
    test_db_path = File.join(Dir.tmpdir, "ocls_test_#{Process.pid}.db")
    db = SQLite3::Database.new(test_db_path)
    db.execute_batch(<<~SQL)
      CREATE TABLE IF NOT EXISTS session (
        id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        slug TEXT NOT NULL,
        directory TEXT NOT NULL,
        title TEXT NOT NULL,
        version TEXT NOT NULL,
        time_created INTEGER NOT NULL,
        time_updated INTEGER NOT NULL,
        parent_id TEXT,
        agent TEXT,
        model TEXT,
        cost REAL DEFAULT 0 NOT NULL,
        tokens_input INTEGER DEFAULT 0 NOT NULL,
        tokens_output INTEGER DEFAULT 0 NOT NULL
      );
    SQL
    db.close
    ENV['OCLS_TEST_DB'] = test_db_path
  end

  # Clear test data between each example for isolation
  config.before do
    db = SQLite3::Database.new(ENV.fetch('OCLS_TEST_DB', nil))
    db.execute('DELETE FROM session')
    db.close
  end

  config.after(:suite) do
    test_db_path = ENV.fetch('OCLS_TEST_DB', nil)
    FileUtils.rm_f(test_db_path) if test_db_path
  end
end

# Helper to get the test database path
def test_db_path
  ENV.fetch('OCLS_TEST_DB', nil)
end

# Helper to insert test sessions into the test database
def insert_test_session(db_path, attrs = {})
  db = SQLite3::Database.new(db_path)
  defaults = {
    'id' => SecureRandom.uuid,
    'project_id' => 'test-project',
    'slug' => 'test-session',
    'directory' => '/home/user/projects/test',
    'title' => 'Test Session',
    'version' => '1.0',
    'time_created' => Time.now.to_i,
    'time_updated' => Time.now.to_i,
    'agent' => 'H',
    'model' => '{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}',
    'cost' => 0.01,
    'tokens_input' => 1000,
    'tokens_output' => 500
  }
  attrs = defaults.merge(attrs)
  columns = attrs.keys.join(', ')
  placeholders = Array.new(attrs.size) { '?' }.join(', ')
  db.execute("INSERT INTO session (#{columns}) VALUES (#{placeholders})", attrs.values)
  db.close
end
