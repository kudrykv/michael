# frozen_string_literal: true

module Michael
  module Models
    class PullRequest
      attr_reader :pull_request
      attr_accessor :statuses, :reviews, :comments

      def initialize(pull_request, statuses: nil, reviews: nil)
        @pull_request = pull_request
        @statuses = statuses
        @reviews = reviews
      end

      def number
        pull_request[:number]
      end

      def head_sha
        pull_request[:head][:sha]
      end
    end
  end
end
