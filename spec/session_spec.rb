# frozen_string_literal: true

RSpec.describe Ocls::Session do
  describe 'attributes' do
    it 'has all required fields' do
      session = described_class.new(
        title: 'Test Session',
        location: '/home/user/projects/test',
        agent: 'H',
        model: 'mimo-v2.5-pro',
        tokens: 1500,
        cost: 0.01
      )

      expect(session.title).to eq('Test Session')
      expect(session.location).to eq('/home/user/projects/test')
      expect(session.agent).to eq('H')
      expect(session.model).to eq('mimo-v2.5-pro')
      expect(session.tokens).to eq(1500)
      expect(session.cost).to eq(0.01)
    end

    it 'supports keyword_init' do
      expect { described_class.new(title: 'Test', location: '/', agent: 'H', model: 'x', tokens: 0, cost: 0.0) }
        .not_to raise_error
    end
  end
end
