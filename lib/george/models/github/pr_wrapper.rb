# frozen_string_literal: true

require_relative 'reviewer'
require_relative 'team'

class PRWrapper
  attr_accessor :statuses, :reviews

  def initialize(pull_request)
    @pr = pull_request
    @statuses = []
    @reviews = []
  end

  def title
    pr[:title]
  end

  def number
    pr[:number]
  end

  def author
    pr[:user][:login]
  end

  def head_sha
    pr[:head][:sha]
  end

  def reviewed?
    reviewers.any? || teams.any?
  end

  def reviewers
    pr[:requested_reviewers].map { |reviewer| Reviewer.new(reviewer) }
  end

  def teams
    pr[:requested_teams].map { |team| Team.new(team) }
  end

  def labels
    pr[:labels].map { |label| label[:name] }
  end

  def requested_changes
    reviews.select(&:changes_requested?).map(&:author)
  end

  def commented_on_pr
    reviews
      .reject { |review| pr.author == review.author }
      .select(&:commented?).map(&:author)
  end

  private

  attr_reader :pr
end
