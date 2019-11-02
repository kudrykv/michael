# frozen_string_literal: true

require 'michael/services/token'

RSpec.describe Michael::Services::Token do
  let(:octokit) { double(:octokit) }
  let(:config) { double(:config) }
  let(:access_token) { 'token-for-github' }

  context 'validate' do
    it 'should be silent when token is valid' do
      stub_const('Octokit', octokit)

      expect(octokit).to receive(:new).with(access_token: :access_token).and_return(octokit)
      expect(octokit).to receive(:scopes).and_return(['repo'])

      tkn = Michael::Services::Token.new(config)

      expect { tkn.validate(:access_token) }.not_to raise_error
    end

    it 'should raise error when token is invalid' do
      stub_const('Octokit', octokit)

      expect(octokit).to receive(:new).with(access_token: :access_token).and_return(octokit)
      expect(octokit).to receive(:scopes).and_raise(Michael::Error, 'not a token')

      tkn = Michael::Services::Token.new(config)

      expect { tkn.validate(:access_token) }.to raise_error(Michael::Error, 'invalid access token')
    end

    it 'should raise error when scope has no `repo` scope' do
      stub_const('Octokit', octokit)

      expect(octokit).to receive(:new).with(access_token: :access_token).and_return(octokit)
      expect(octokit).to receive(:scopes).and_return(['no', 'nopes', 'not here'])

      tkn = Michael::Services::Token.new(config)
      expect { tkn.validate(:access_token) }
        .to raise_error(Michael::Error, 'access token must contain `repo` scope')
    end
  end

  context 'store' do
    it 'should store the token' do
      expect(config).to receive(:set).with(:token, value: access_token)

      tkn = Michael::Services::Token.new(config)

      expect { tkn.store(access_token) }.not_to raise_error
    end
  end
end
