# frozen_string_literal: true

require 'michael/models/pull_request'
require 'michael/models/review'

RSpec.describe Michael::Models::PullRequest do
  Label = Struct.new(:name)

  let(:pr_number) { 42 }
  let(:sha) { 'sha' }
  let(:author) { 'deadbeef' }
  let(:title) { 'that is a great title' }
  let(:labels) { %w[shiny label] }

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

  end

  context :labels do
    it 'should return list of labels' do
      expect(pr.labels).to contain_exactly(*labels)
    end
  end

  context :approved? do
    context 'when there are no reviews' do
      it 'should tell pr is not approved' do
        expect(pr.approved?).to be_falsey
      end
    end

    context 'when reviews have no approved review' do
      it 'should tell pr is not approved' do
        pr.reviews = [Michael::Models::Review.new(state: 'COMMENTED')]

        expect(pr.approved?).to be_falsey
      end
    end

    context 'when review has some of all approved reviews' do
      it 'should should tell pr is not approved' do
        pr.reviews = [
          Michael::Models::Review.new(state: 'APPROVED'),
          Michael::Models::Review.new(state: 'COMMENTED')
        ]

        expect(pr.approved?).to be_falsey
      end
    end

    context 'when all reviews are approving' do
      it 'should should tell pr is approved' do
        pr.reviews = [Michael::Models::Review.new(state: 'APPROVED')]

        expect(pr.approved?).to be_truthy
      end
    end
  end
  
  context :needs_review? do
    context 'when there are no attached requested reviewers or teams' do
      let(:raw_pr) { { requested_reviewers: [], requested_teams: [] } }
      let(:pr) { Michael::Models::PullRequest.new(raw_pr) }

      it 'should say no need for review' do
        expect(pr.needs_review?).to be_falsey
      end
    end

    context 'when there is a reviewer' do
      let(:raw_pr) do
        {
          requested_reviewers: [{ todo: true }],
          requested_teams: []
        }
      end
      let(:pr) { Michael::Models::PullRequest.new(raw_pr) }

      it 'should say the review is needed' do
        expect(pr.needs_review?).to be_truthy
      end
    end

    context 'when team was requested for a review' do
      let(:raw_pr) do
        {
          requested_reviewers: [],
          requested_teams: [{ todo: true }]
        }
      end
      let(:pr) { Michael::Models::PullRequest.new(raw_pr) }

      it 'should should say the review is needed' do
        expect(pr.needs_review?).to be_truthy
      end
    end
  end

  context :author? do
    let(:moment) { Time.now }
    let(:raw_pr) do
      { user: { login: author } }
    end

    let(:pr) { Michael::Models::PullRequest.new(raw_pr) }

    context 'when the author name matches passed' do
      it 'should confirm the user is the author' do
        expect(pr.author?(author)).to be_truthy
      end
    end

    context 'when the author name mismatch passed' do
      it 'should deny the user is the author' do
        expect(pr.author?(author + author)).to be_falsey
      end
    end
  end

  context :actionable? do
    let(:moment) { Time.now }
    let(:ago) { moment - 60 }
    let(:after) { moment + 60 }
    let(:alice) { 'alice' }
    let(:bob) { 'bob' }
    let(:raw_pr) { { user: { login: author }, updated_at: moment } }
    let(:pr) do
      r = Michael::Models::PullRequest.new(raw_pr)
      r.reviews = [Michael::Models::Review.new(state: 'COMMENTED', user: { login: alice }, submitted_at: ago)]

      r
    end

    context 'when PR author name matches current user' do
      it 'should be considered as non-actionable' do
        expect(pr.actionable?(author)).to be_falsey
      end
    end

    context 'when PR has no reviews from the current user' do
      it 'should be considered as actionable' do
        expect(pr.actionable?(bob)).to be_truthy
      end
    end

    context 'when PR has a review from the current user' do
      context 'when the last update has been to the head' do
        it 'should be considered as actionable' do
          expect(pr.actionable?(alice)).to be_truthy
        end
      end

      context 'when the last update has been from the review' do
        let(:pr) do
          r = Michael::Models::PullRequest.new(raw_pr)
          r.reviews = [Michael::Models::Review.new(state: 'COMMENTED', user: { login: alice }, submitted_at: after)]

          r
        end

        it 'should be concidered as non-actionable' do
          expect(pr.actionable?(alice)).to be_falsey
        end
      end
    end
  end
end
