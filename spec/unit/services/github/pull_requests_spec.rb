# frozen_string_literal: true

require_relative '../../../../lib/michael/services/github/pull_requests'

RSpec.describe Michael::Services::Github::PullRequests do
  let(:octokit) { double(:octokit) }
  let(:cfg) { double(:cfg) }
  let(:access_token) { 'token' }
  let(:scopes) { ['repo'] }
  let(:pr) { Michael::Services::Github::PullRequests }
  let(:pr_number) { 42 }
  let(:org_repo) { 'org/repo' }
  let(:default_search_params) { { state: 'open' } }
  let(:sha) { 'sha' }
  let(:login_alice) { 'alice' }
  let(:now) { Time.now }

  let(:org_repo_prs) do
    [{
      number: pr_number,
      head: {
        sha: sha
      }
    }]
  end

  let(:org_repo_statuses) do
    [{

    }]
  end

  let(:org_repo_reviews) do
    [{
      user: {
        login: login_alice
      },
      submitted_at: now
    }]
  end

  before(:each) do
    allow(cfg).to receive(:fetch).with(:token).and_return(access_token)

    allow(octokit).to receive(:new).with(access_token: access_token).and_return(octokit)
    allow(octokit).to receive(:scopes).and_return(scopes)

    stub_const('Octokit::Client', octokit)
  end

  context 'search' do
    it 'should return list or PRs' do
      allow(octokit).to receive(:pull_requests).with(org_repo, default_search_params).and_return(org_repo_prs)
      allow(octokit).to receive(:combined_status).with(org_repo, sha).and_return(org_repo_statuses)
      allow(octokit).to receive(:pull_request_reviews).with(org_repo, pr_number).and_return(org_repo_reviews)

      list = pr.new(cfg).search(org_repo)
      expect(list.length).to be(1)
    end
  end
end
