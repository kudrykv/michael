# frozen_string_literal: true

module Michael
  module Models
    class PullRequest
      attr_reader :pull_request, :statuses, :reviews, :comments

      def initialize(pull_request, statuses: nil, reviews: nil)
        @pull_request = pull_request
        @statuses = statuses
        @reviews = reviews
      end

      def number
        pr[:number]
      end

      def head_sha
        pr[:head][:sha]
      end
    end
  end
end
