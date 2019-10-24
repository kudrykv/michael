# frozen_string_literal: true
class Status
  def initialize(status)
    @status = status
  end

  def state
    status[:state].to_sym
  end

  def updated_at
    status[:updated_at]
  end

  private

  attr_reader :status
end