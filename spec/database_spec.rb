# frozen_string_literal: true

RSpec.describe Database do
  describe '#recent_sessions' do
    context 'with a valid database' do
      before do
        # Insert test data with explicit time_created ordering
        insert_test_session(test_db_path, {
                              'id' => 'session-1',
                              'title' => 'First Session',
                              'directory' => '/home/user/projects/first',
                              'agent' => 'H',
                              'model' => '{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}',
                              'tokens_input' => 1000,
                              'tokens_output' => 500,
                              'cost' => 0.01,
                              'time_created' => 1000
                            })
        insert_test_session(test_db_path, {
                              'id' => 'session-2',
                              'title' => 'Second Session',
                              'directory' => '/home/user/projects/second',
                              'agent' => 'subagents/url-examiner',
                              'model' => '{"id":"deepseek/deepseek-v4-flash","providerID":"openrouter"}',
                              'tokens_input' => 2000,
                              'tokens_output' => 1000,
                              'cost' => 0.02,
                              'time_created' => 2000
                            })
        insert_test_session(test_db_path, {
                              'id' => 'session-3',
                              'title' => 'Third Session',
                              'directory' => '/home/user/projects/third',
                              'agent' => 'H',
                              'model' => nil,
                              'tokens_input' => 500,
                              'tokens_output' => 200,
                              'cost' => 0.005,
                              'time_created' => 3000
                            })
      end

      it 'returns sessions ordered by time_created DESC' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        expect(sessions.length).to eq(3)
        expect(sessions.first.title).to eq('Third Session')
        expect(sessions.last.title).to eq('First Session')
      end

      it 'respects the limit parameter' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 2)

        expect(sessions.length).to eq(2)
      end

      it 'extracts model short name from JSON' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        first_model = sessions.find { |s| s.title == 'First Session' }.model
        expect(first_model).to eq('mimo-v2.5-pro')
      end

      it 'handles nil model' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        third_model = sessions.find { |s| s.title == 'Third Session' }.model
        expect(third_model).to eq('unknown')
      end

      it 'sums tokens_input and tokens_output' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        first_tokens = sessions.find { |s| s.title == 'First Session' }.tokens
        expect(first_tokens).to eq(1500)
      end

      it 'returns Session structs' do
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        expect(sessions).to all(be_a(Session))
      end

      it 'handles empty title as (untitled)' do
        insert_test_session(test_db_path, {
                              'id' => 'session-empty',
                              'title' => '',
                              'time_created' => 4000
                            })
        db = described_class.new(test_db_path)
        sessions = db.recent_sessions(limit: 10)

        untitled = sessions.find { |s| s.title == '(untitled)' }
        expect(untitled).not_to be_nil
      end
    end

    context 'with a missing database' do
      it 'raises DatabaseNotFoundError' do
        db = described_class.new('/nonexistent/path/db.sqlite')

        expect { db.recent_sessions }.to raise_error(DatabaseNotFoundError)
      end
    end
  end
end
