# frozen_string_literal: true

require_relative 'initializer'
require_relative '../../models/pull_request'
require_relative '../../models/status'
require_relative '../../models/review'

module Michael
  module Services
    module Github
      class PullRequests < Initializer
        def search(org_repo, state: 'open')
          octokit
            .pull_requests(org_repo, state: state)
            .map { |pr| process(org_repo, pr) }
        rescue Octokit::InvalidRepository
          nil
        end

        private

        def process(org_repo, pull_request)
          Michael::Models::PullRequest.new(
            pull_request,
            statuses: statuses(org_repo, pr.head_sha),
            reviews: reviews(org_repo, pr.number)
          )
        end

        def statuses(org_repo, sha)
          octokit
            .combined_status(org_repo, sha)
            .map { |s| Michael::Models::Status.new(s) }
        end

        def reviews(org_repo, pr_number)
          octokit
            .pull_request_reviews(org_repo, pr_number)
            .map { |review| Review.new(review) }
            .group_by(&:author).to_a
            .map { |_author, reviews| reviews.sort_by(&:submitted_at).pop }
        end
      end
    end
  end
end
