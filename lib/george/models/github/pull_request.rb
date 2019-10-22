# frozen_string_literal: true

require 'octokit'

require_relative 'octokit_initializer'
require_relative 'pr_wrapper'
require_relative 'review'
require_relative 'status'

class PullRequest < OctokitInitializer
  def search(org_repo, state: 'open')
    octokit.pull_requests(org_repo, state: state).map { |pr| PRWrapper.new(pr) }
  rescue StandardError
    false
  end

  def search_many(org_repo_list, state: 'open')
    org_repo_list.each_with_object(repos: [], broken: []) do |org_repo, acc|
      list = search(org_repo, state: state)
      unless list
        acc[:broken].push(org_repo)
        next
      end

      acc[:repos].push(repo: org_repo, prs: list)
    end
  end

  def pr(org_repo, pr_number)
    PRWrapper.new octokit.pull_request(org_repo, pr_number)
  end

  def statuses(org_repo, ref)
    combined = octokit.combined_status(org_repo, ref)
    combined[:statuses]&.map { |status| Status.new(status) }
  end

  def reviews(org_repo, pr_number)
    octokit
      .pull_request_reviews(org_repo, pr_number)
      .map { |review| Review.new(review) }
  end
end
