# frozen_string_literal: true

require 'octokit'

require_relative 'octokit_initializer'
require_relative 'pr_wrapper'
require_relative 'review'
require_relative 'status'

class PullRequest < OctokitInitializer
  def search(org_repo, state: 'open', with_statuses: true, with_reviews: true)
    octokit.pull_requests(org_repo, state: state).map do |pr|
      pr = PRWrapper.new(pr)
      pr.statuses = statuses(org_repo, pr.head_sha) if with_statuses
      pr.reviews = reviews(org_repo, pr.number) if with_reviews

      pr
    end
  rescue Octokit::InvalidRepository
    false
  end

  def search_many(org_repo_list, state: 'open', with_statuses: true, with_reviews: true)
    groups = org_repo_list.each_slice(org_repo_list.length / 5 + 1).to_a

    threads = []

    groups.map.each_with_index do |group, index|
      threads << Thread.new(group, index) do |gr, i|
        gr.map do |org_repo|
          process_one(org_repo, state: state, with_statuses: with_statuses, with_reviews: with_reviews)
        end
      end
    end

    threads.map(&:join).map(&:value).flatten
  end

  def process_one(org_repo, state: 'open', with_statuses: true, with_reviews: true)
    list = search(
      org_repo, state: state,
                with_statuses: with_statuses,
                with_reviews: with_reviews
    )

    return { repo: org_repo, state: :failed } unless list

    { repo: org_repo, state: :success, prs: list }
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
