# frozen_string_literal: true

require_relative '../../../lib/michael/models/pull_request'

RSpec.describe Michael::Models::PullRequest do
  Label = Struct.new(:name)

  let(:pr_number) { 42 }
  let(:sha) { 'sha' }
  let(:author) { 'deadbeef' }
  let(:title) { 'that is a great title' }
  let(:labels) { ['shiny', 'label'] }

  let(:raw_pr) do
    {
      number: pr_number,
      title: title,
      user: {
        login: author
      },
      head: {
        sha: sha
      },
      labels: [Label.new('shiny'), Label.new('label')]
    }
  end

  let(:pr) { Michael::Models::PullRequest.new(raw_pr) }

  context 'simple methods' do
    context :number do
      it 'should return a number' do
        expect(pr.number).to eq(pr_number)
      end
    end

    context :title do
      it 'should return title' do
        expect(pr.title).to eq(title)
      end
    end

    context :author do
      it 'should return an author' do
        expect(pr.author).to eq(author)
      end
    end

    context :head_sha do
      it 'should should return sha number' do
        expect(pr.head_sha).to eq(sha)
      end
    end

    context :labels do
      it 'should return list of labels' do
        expect(pr.labels).to contain_exactly(*labels)
      end
    end
  end
end
