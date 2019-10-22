# frozen_string_literal: true

require 'pastel'

class PullRequestFormatter
  def initialize(pr)
    @pastel = Pastel.new
    @pr = pr
  end

  def pretty
    format(
      '#%<number>s %<statuses>s %<reviews>s %<title>s %<variable>s',
      number: pastel.bold(pr.number),
      statuses: statuses_in_dots,
      reviews: reviews_in_dots,
      title: pr.title,
      variable: variable_line
    )
  end

  private

  attr_reader :pastel, :pr


  def statuses_in_dots
    pr.statuses.map { |status| dot_status[status.state] }.join
  end

  def reviews_in_dots
    return pastel.red('.') unless pr.reviewed? || pr.reviews.any?
    return pastel.yellow('.') if pr.reviews.empty?

    pr.reviews
      .reject { |review| review.author == pr.author }
      .map { |review| dot_status[review.state] }
      .join
  end

  def variable_line
    [
      labels_stringified(pr.labels),
      pastel.cyan(pr.author),
      who_req_changes_stringified,
      who_commented_stringified
    ].reject(&:empty?).join(' ')
  end

  def labels_stringified(labels)
    return '' if labels.empty?

    pastel.bold.yellow("[#{labels.join(', ')}]")
  end

  def who_commented_stringified
    names = pr.commented_on_pr
    return '' if names.empty?

    '| Commented: ' + names.join(', ')
  end

  def who_req_changes_stringified
    names = pr.requested_changes
    return '' if names.empty?

    '| ' + pastel.bold('Requested changes: ') << names.map { |name| pastel.underscore(name) }.join(', ')
  end

  def dot_status
    @dot_status ||= {
      success: pastel.green('+'),
      pending: pastel.yellow('.'),
      error: pastel.red('x'),
      failure: pastel.red('x'),
      APPROVED: pastel.green('^'),
      CHANGES_REQUESTED: pastel.red('X'),
      COMMENTED: '-'
    }
  end
end
