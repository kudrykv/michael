# frozen_string_literal: true

class Review
  def initialize(review)
    @review = review
  end

  def author
    review[:user][:login]
  end

  def state
    review[:state]
  end

  def submitted_at
    review[:submitted_at]
  end

  def changes_requested?
    state == 'CHANGES_REQUESTED'
  end

  def commented?
    state == 'COMMENTED'
  end

  private

  attr_reader :review
end
