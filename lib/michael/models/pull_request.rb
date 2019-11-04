# frozen_string_literal: true

require 'pastel'

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

      def title
        pull_request[:title]
      end

      def head_sha
        pull_request[:head][:sha]
      end

      def pretty_print
        [
          pastel.bold("\##{number}"),
          title
        ].join(' ')
      end

      private

      def pastel
        @pastel ||= Pastel.new
      end
    end
  end
end
