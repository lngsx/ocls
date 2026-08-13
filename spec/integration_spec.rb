# frozen_string_literal: true

RSpec.describe 'ocls end-to-end' do
  before do
    # Insert several test sessions with varying data
    insert_test_session(test_db_path, {
                          'id' => 'e2e-1',
                          'title' => 'Compare pacific-rails-6 and pacific repositories',
                          'directory' => '/home/luang/.local/share/opencode',
                          'agent' => 'H',
                          'model' => '{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}',
                          'tokens_input' => 40_000,
                          'tokens_output' => 6729,
                          'cost' => 0.0235,
                          'time_created' => 1000
                        })
    insert_test_session(test_db_path, {
                          'id' => 'e2e-2',
                          'title' => 'Project logging system investigation',
                          'directory' => '/home/luang/projects/pacific-rails-6',
                          'agent' => 'H',
                          'model' => '{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}',
                          'tokens_input' => 17_218,
                          'tokens_output' => 4908,
                          'cost' => 0.0106,
                          'time_created' => 2000
                        })
    insert_test_session(test_db_path, {
                          'id' => 'e2e-3',
                          'title' => 'Content-Examiner Web Fetching: Reuse or Fork?',
                          'directory' => '/home/luang/.local/share/opencode',
                          'agent' => 'H',
                          'model' => '{"id":"openai/gpt-5.6-terra","providerID":"openai"}',
                          'tokens_input' => 15_000,
                          'tokens_output' => 4159,
                          'cost' => 1.8782,
                          'time_created' => 3000
                        })
  end

  it 'renders styled card output matching the spec' do
    db = Database.new(test_db_path)
    sessions = db.recent_sessions(limit: 15)
    renderer = Renderer.new
    output = renderer.render(sessions)

    # Verify titles
    expect(output).to include('Compare pacific-rails-6 and pacific repositories')
    expect(output).to include('Project logging system investigation')
    expect(output).to include('Content-Examiner Web Fetching: Reuse or Fork?')

    # Verify model+cost on one line with divider
    expect(output).to include("mimo-v2.5-pro \u254D $0.0235 (46,729)")
    expect(output).to include("mimo-v2.5-pro \u254D $0.0106 (22,126)")
    expect(output).to include("gpt-5.6-terra \u254D $1.8782 (19,159)")

    # Verify no labels
    expect(output).not_to include('Agent:')
    expect(output).not_to include('Model:')
    expect(output).not_to include('Tokens:')
    expect(output).not_to include('Cost:')

    # Verify separator
    expect(output.scan("\u2500" * 80).length).to eq(3)

    # Verify ordering (most recent first)
    lines = output.lines
    first_title_idx = lines.index { |l| l.include?('Content-Examiner') }
    last_title_idx = lines.index { |l| l.include?('Compare pacific') }
    expect(first_title_idx).to be < last_title_idx
  end

  it 'handles the full CLI flow' do
    db = Database.new(test_db_path)
    allow(Database).to receive(:new).and_return(db)

    expect { CLI.start(%w[list 2]) }
      .to output(/Content-Examiner/).to_stdout
  end

  it 'prints nothing for empty results' do
    # Use a fresh empty DB
    require 'tmpdir'
    empty_db_path = File.join(Dir.tmpdir, "ocls_empty_test_#{Process.pid}.db")
    empty_db = SQLite3::Database.new(empty_db_path)
    empty_db.execute_batch(<<~SQL)
      CREATE TABLE session (
        id TEXT PRIMARY KEY, project_id TEXT, slug TEXT, directory TEXT,
        title TEXT, version TEXT, time_created INTEGER, time_updated INTEGER,
        agent TEXT, model TEXT, cost REAL, tokens_input INTEGER, tokens_output INTEGER
      );
    SQL
    empty_db.close

    db = Database.new(empty_db_path)
    sessions = db.recent_sessions(limit: 15)
    renderer = Renderer.new
    output = renderer.render(sessions)

    expect(output).to eq('')

    FileUtils.rm_f(empty_db_path)
  end
end
