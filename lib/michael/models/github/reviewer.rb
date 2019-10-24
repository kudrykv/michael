# frozen_string_literal: true

module Michael
  module Models
    module Github
      class Reviewer
        def initialize(reviewer)
          @reviewer = reviewer
        end

        private

        attr_reader :reviewer
      end
    end
  end
end