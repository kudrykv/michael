# frozen_string_literal: true

module Michael
  module Models
    module Github
      class Team
        def initialize(team)
          @team = team
        end

        private

        attr_reader :team
      end
    end
  end
end