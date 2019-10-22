# frozen_string_literal: true

require_relative 'reviewer'
require_relative 'team'

class PRWrapper
  def initialize(pull_request)
    @pr = pull_request
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

  private

  attr_reader :pr
end
