# frozen_string_literal: true

require_relative '../../../lib/michael/models/pull_request'

RSpec.describe Michael::Models::PullRequest do
  let(:pr_number) { 42 }
  let(:sha) { 'sha' }
  let(:raw_pr) do
    {
      number: pr_number,
      head: {
        sha: sha
      }
    }
  end

  context 'pull request' do
    it 'should return number' do
      pr = Michael::Models::PullRequest.new(raw_pr)
      expect(pr.number).to be(pr_number)
    end

    it 'should should return sha number' do
      pr = Michael::Models::PullRequest.new(raw_pr)
      expect(pr.head_sha).to be(sha)
    end
  end
end
