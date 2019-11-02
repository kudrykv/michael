# frozen_string_literal: true

require_relative '../../../../lib/michael/services/github/initializer'

RSpec.describe Michael::Services::Github::Initializer do
  let(:octokit) { double(:octokit) }
  let(:cfg) { double(:cfg) }
  let(:access_token) { 'token' }
  let(:exception) { Michael::Error }

  it 'should raise exception when config is nil' do
    expect { Michael::Services::Github::Initializer.new(nil) }.to raise_error(Michael::Error, 'config is nil')
  end

  it 'should raise exception when token is invalid' do
    stub_const('Octokit::Client', octokit)
    stub_const('Octokit::Unauthorized', exception)

    expect(cfg).to receive(:fetch).with(:token).and_return(access_token)
    expect(octokit).to receive(:new).with(access_token: access_token).and_raise(exception)

    expect { Michael::Services::Github::Initializer.new(cfg) }.to raise_error(exception, 'invalid access token')
  end
end
