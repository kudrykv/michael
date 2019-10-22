# frozen_string_literal: true

require 'octokit'
require 'tty-spinner'

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
    spin = spinner('[:spinner] :title')
    spin.update(title: 'get PRs...')
    spin.spin
    result = org_repo_list.each_with_object(repos: [], broken: []).with_index do |(org_repo, acc), i|
      spin.update(title: "[#{i + 1}/#{org_repo_list.length}] inspecting #{org_repo}...")
      spin.spin

      list = search(
        org_repo, state: state,
        with_statuses: with_statuses,
        with_reviews: with_reviews
      )

      unless list
        acc[:broken].push(org_repo)
        next
      end

      acc[:repos].push(repo: org_repo, prs: list)
    end

    spin.success('completed')

    result
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

  private

  def spinner(*args)
    TTY::Spinner.new(*args)
  end
end
