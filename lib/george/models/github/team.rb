# frozen_string_literal: true

class Team
  def initialize(team)
    @team = team
  end

  private

  attr_reader :team
end
