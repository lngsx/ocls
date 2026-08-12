# frozen_string_literal: true

RSpec.describe Ocls::CLI do
  describe '#list' do
    context 'with valid database' do
      before do
        insert_test_session(test_db_path, {
                              'id' => 'cli-session-1',
                              'title' => 'CLI Test Session',
                              'directory' => '/home/user/projects/cli-test',
                              'agent' => 'H',
                              'model' => '{"id":"openrouter/xiaomi/mimo-v2.5-pro","providerID":"openrouter"}',
                              'tokens_input' => 1000,
                              'tokens_output' => 500,
                              'cost' => 0.01,
                              'time_created' => 5000
                            })
      end

      it 'prints session output to stdout' do
        # Stub Database.new to use test DB
        db = Ocls::Database.new(test_db_path)
        allow(Ocls::Database).to receive(:new).and_return(db)

        expect { described_class.start(['list']) }
          .to output(/CLI Test Session/).to_stdout
      end

      it 'accepts a numeric limit argument' do
        db = Ocls::Database.new(test_db_path)
        allow(Ocls::Database).to receive(:new).and_return(db)

        expect { described_class.start(%w[list 5]) }
          .to output(/CLI Test Session/).to_stdout
      end
    end

    context 'with missing database' do
      it 'prints error to stderr and exits' do
        db = Ocls::Database.new('/nonexistent/path/db.sqlite')
        allow(Ocls::Database).to receive(:new).and_return(db)

        expect { described_class.start(['list']) }
          .to output(/Database not found/).to_stderr
          .and raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      end
    end
  end

  describe '#version' do
    it 'prints the version' do
      expect { described_class.start(['version']) }
        .to output(/ocls #{Ocls::VERSION}/).to_stdout
    end
  end
end
