# frozen_string_literal: true

require 'octokit'

require_relative 'octokit_initializer'
require_relative 'pr_wrapper'
require_relative 'review'

class PullRequest < OctokitInitializer
  def search(org_repo, state: 'open')
    octokit.pull_requests(org_repo, state: state).map { |pr| PRWrapper.new(pr) }
  rescue StandardError
    false
  end

  def pr(org_repo, pr_number)
    PRWrapper.new octokit.pull_request(org_repo, pr_number)
  end

  def statuses(org_repo, ref)
    octokit.combined_status org_repo, ref
  end

  def reviews(org_repo, pr_number)
    octokit
      .pull_request_reviews(org_repo, pr_number)
      .map { |review| Review.new(review) }
  end
end
