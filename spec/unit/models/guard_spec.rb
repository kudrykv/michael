# frozen_string_literal: true

require 'michael/models/guard'
require 'michael/models/github/token_validator'

RSpec.describe Michael::Models::Guard do
  let(:config) { double(:config) }
  let(:validator) { double(:validator) }

  context 'token is valid' do
    it 'should initialize object' do
      expect(config).to receive(:new).and_return(config)
      expect(config)
        .to receive(:new)
        .with(config_name: 'repositories')
        .and_return(config)

      expect(config).to receive(:fetch).with(:token).and_return('tkn')

      expect(validator).to receive(:token_valid?).with('tkn').and_return(true)

      stub_const('Michael::Models::Configuration', config)
      stub_const('Michael::Models::Github::TokenValidator', validator)

      Michael::Models::Guard.new
    end
  end

  context 'token is invalid' do
    it 'should raise system error' do
      expect(config).to receive(:new).and_return(config)
      expect(config)
        .to receive(:new)
              .with(config_name: 'repositories')
              .and_return(config)

      expect(config).to receive(:fetch).with(:token).and_return('tkn')

      expect(validator).to receive(:token_valid?).with('tkn').and_return(false)

      stub_const('Michael::Models::Configuration', config)
      stub_const('Michael::Models::Github::TokenValidator', validator)

      expect { Michael::Models::Guard.new }.to raise_error SystemExit
    end
  end
end
