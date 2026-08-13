# frozen_string_literal: true

RSpec.describe Renderer do
  let(:pastel) { Pastel.new(enabled: false) }
  let(:renderer) { described_class.new(pastel: pastel) }

  describe '#render' do
    let(:sessions) do
      [
        Session.new(
          title: 'Test Session',
          location: '/home/user/projects/test',
          agent: 'H',
          model: 'mimo-v2.5-pro',
          tokens: 1500,
          cost: 0.0123
        )
      ]
    end

    it 'renders a card with separator, title, model+cost, location' do
      output = renderer.render(sessions)

      expect(output).to include('Test Session')
      expect(output).to include('/home/user/projects/test')
      expect(output).to include('mimo-v2.5-pro')
      expect(output).to include('$0.0123')
      expect(output).to include('(1,500)')
    end

    it 'does not include field labels' do
      output = renderer.render(sessions)

      expect(output).not_to include('Agent:')
      expect(output).not_to include('Model:')
      expect(output).not_to include('Tokens:')
      expect(output).not_to include('Cost:')
      expect(output).not_to include('Location:')
    end

    it 'uses Unicode box-drawing separator' do
      output = renderer.render(sessions)

      expect(output).to include("\u2500" * 80)
    end

    it 'uses heavy dashed divider between model and cost' do
      output = renderer.render(sessions)

      expect(output).to include("\u254D")
      expect(output).to include("mimo-v2.5-pro \u254D $0.0123 (1,500)")
    end

    it 'formats tokens with commas' do
      big_session = Session.new(
        title: 'Big Session',
        location: '/tmp',
        agent: 'H',
        model: 'mimo-v2.5-pro',
        tokens: 123_456,
        cost: 0.01
      )
      output = renderer.render([big_session])

      expect(output).to include('(123,456)')
    end

    it 'formats cost to 4 decimal places' do
      output = renderer.render(sessions)

      expect(output).to include('$0.0123')
    end

    context 'with empty sessions' do
      it 'returns empty string' do
        expect(renderer.render([])).to eq('')
      end
    end

    context 'with multiple sessions' do
      it 'renders multiple cards with separators' do
        sessions = [
          Session.new(title: 'First', location: '/a', agent: 'H', model: 'x', tokens: 0, cost: 0.0),
          Session.new(title: 'Second', location: '/b', agent: 'H', model: 'x', tokens: 0, cost: 0.0)
        ]
        output = renderer.render(sessions)

        expect(output.scan("\u2500" * 80).length).to eq(2)
        expect(output).to include('First')
        expect(output).to include('Second')
      end
    end

    context 'with subagent' do
      it 'suffixes title with (subagent)' do
        session = Session.new(
          title: 'Fetch docs',
          location: '/tmp',
          agent: 'subagents/url-examiner',
          model: 'deepseek-v4-flash',
          tokens: 15_590,
          cost: 0.0024
        )
        output = renderer.render([session])

        expect(output).to include('Fetch docs (subagent)')
      end

      it 'does not show the raw agent path' do
        session = Session.new(
          title: 'Fetch docs',
          location: '/tmp',
          agent: 'subagents/url-examiner',
          model: 'deepseek-v4-flash',
          tokens: 15_590,
          cost: 0.0024
        )
        output = renderer.render([session])

        expect(output).not_to include('subagents/url-examiner')
      end
    end

    context 'with main agent' do
      it 'does not suffix title' do
        session = Session.new(
          title: 'Test Session',
          location: '/tmp',
          agent: 'H',
          model: 'mimo-v2.5-pro',
          tokens: 1000,
          cost: 0.01
        )
        output = renderer.render([session])

        expect(output).to include('Test Session')
        expect(output).not_to include('(subagent)')
      end
    end

    context 'with title containing existing subagent suffix' do
      it 'strips the existing suffix and uses clean suffix' do
        session = Session.new(
          title: 'Fetch dry-struct docs (@subagents/url-examiner subagent)',
          location: '/tmp',
          agent: 'subagents/url-examiner',
          model: 'deepseek-v4-flash',
          tokens: 15_590,
          cost: 0.0024
        )
        output = renderer.render([session])

        expect(output).to include('Fetch dry-struct docs (subagent)')
        expect(output).not_to include('(@subagents/url-examiner subagent)')
      end
    end
  end
end
