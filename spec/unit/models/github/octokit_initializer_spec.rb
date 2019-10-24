# frozen_string_literal: true

require 'michael/models/github/octokit_initializer'

RSpec.describe Michael::Models::Github::OctokitInitializer do
  let(:config) { double(:config) }
  let(:octokit) { double(:octokit) }

  context 'octokit tries to initialize itself' do
    it 'should initialize octokit' do
      expect(config).to receive(:new).and_return(config)
      expect(config).to receive(:fetch).with(:token).and_return('tkn')
      expect(octokit).to receive(:new)
        .with(access_token: 'tkn').and_return(octokit)
      expect(octokit).to receive(:auto_paginate=).with(true)

      stub_const('Michael::Models::Configuration', config)
      stub_const('Octokit::Client', octokit)

      Michael::Models::Github::OctokitInitializer.new
    end
  end
end
