# frozen_string_literal: true

require 'pastel'

class RepoFormatter
  def initialize(name, prs, statuses, reviews)
    @pastel = Pastel.new
    @name = name
    @prs = prs
    @statuses = statuses
    @reviews = reviews
  end

  def pretty
    format(
      '#%<number>s %<statuses>s %<reviews>s %<title>s %<variable>s',
      number: pastel.bold(pr.number),
      statuses: statuses_to_dots(statuses).join,
      reviews: reviews_to_dots(pr, reviews).join,
      title: pr.title,
      variable: postfix_line_stringified(pr, reviews)
    )
  end

  private

  attr_reader :pastel, :name, :prs, :statuses, :reviews
end
