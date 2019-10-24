# frozen_string_literal: true

require 'michael/models/github/pr_wrapper'

RSpec.describe Michael::Models::Github::PRWrapper do
  context 'basic getter stuff' do
    pr_hash = {
      title: 'bad robot',
      number: 42,
      user: { login: 'octokit' },
      head: { sha: 'deadbeef' }
    }

    pr = Michael::Models::Github::PRWrapper.new(pr_hash)

    it 'should get title' do
      expect(pr.title).to eql(pr_hash[:title])
    end

    it 'should get PR number' do
      expect(pr.number).to eql(pr_hash[:number])
    end

    it 'should get author' do
      expect(pr.author).to eql(pr_hash[:user][:login])
    end

    it 'should should get head sha' do
      expect(pr.head_sha).to eql(pr_hash[:head][:sha])
    end
  end
end
