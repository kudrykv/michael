# frozen_string_literal: true

module Michael
  module Models
    class Review
      def initialize(review)
        @review = review
      end

      def author
        review[:user][:login]
      end

      def submitted_at
        review[:submitted_at]
      end

      private

      attr_reader :review
    end
  end
end
