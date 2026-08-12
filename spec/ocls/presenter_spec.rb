# frozen_string_literal: true

RSpec.describe Ocls::Presenter do
  let(:pastel) { Pastel.new(enabled: false) }
  let(:presenter) { described_class.new(width: 80, pastel: pastel) }

  describe '#render' do
    let(:sessions) do
      [
        Ocls::Session.new(
          title: 'Test Session',
          location: '/home/user/projects/test',
          agent: 'H',
          model: 'mimo-v2.5-pro',
          tokens: 1500,
          cost: 0.0123
        )
      ]
    end

    it 'renders a card with separator, title, agent/model, tokens/cost, location' do
      output = presenter.render(sessions)

      expect(output).to include('Test Session')
      expect(output).to include('Agent: H')
      expect(output).to include('Model: mimo-v2.5-pro')
      expect(output).to include('Tokens: 1,500')
      expect(output).to include('Cost: $0.0123')
      expect(output).to include('Location: /home/user/projects/test')
    end

    it 'uses Unicode box-drawing separator' do
      output = presenter.render(sessions)

      expect(output).to include("\u2500" * 80)
    end

    it 'formats tokens with commas' do
      big_session = Ocls::Session.new(
        title: 'Big Session',
        location: '/tmp',
        agent: 'H',
        model: 'mimo-v2.5-pro',
        tokens: 123_456,
        cost: 0.01
      )
      output = presenter.render([big_session])

      expect(output).to include('Tokens: 123,456')
    end

    it 'formats cost to 4 decimal places' do
      output = presenter.render(sessions)

      expect(output).to include('Cost: $0.0123')
    end

    context 'with empty sessions' do
      it 'returns empty string' do
        expect(presenter.render([])).to eq('')
      end
    end

    context 'with long title' do
      it 'truncates with ...' do
        long_title = 'A' * 100
        session = Ocls::Session.new(
          title: long_title,
          location: '/tmp',
          agent: 'H',
          model: 'test',
          tokens: 0,
          cost: 0.0
        )
        output = presenter.render([session])

        expect(output).to include('...')
        expect(output).not_to include(long_title)
      end
    end

    context 'with long location' do
      it 'truncates with ...' do
        long_location = "/home/user/#{'a' * 100}"
        session = Ocls::Session.new(
          title: 'Test',
          location: long_location,
          agent: 'H',
          model: 'test',
          tokens: 0,
          cost: 0.0
        )
        output = presenter.render([session])

        expect(output).to include('Location:')
        # The location line should be truncated
        expect(output.lines.any? { |l| l.include?('Location:') && l.include?('...') }).to be true
      end
    end

    context 'with multiple sessions' do
      it 'renders multiple cards with separators' do
        sessions = [
          Ocls::Session.new(title: 'First', location: '/a', agent: 'H', model: 'x', tokens: 0, cost: 0.0),
          Ocls::Session.new(title: 'Second', location: '/b', agent: 'H', model: 'x', tokens: 0, cost: 0.0)
        ]
        output = presenter.render(sessions)

        expect(output.scan("\u2500" * 80).length).to eq(2)
        expect(output).to include('First')
        expect(output).to include('Second')
      end
    end
  end
end
