# frozen_string_literal: true
class Status
  def initialize(status)
    @status = status
  end

  def state
    status[:state].to_sym
  end

  private

  attr_reader :status
end