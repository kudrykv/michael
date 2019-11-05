# frozen_string_literal: true

require 'pastel'

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

      def state
        review[:state].to_sym
      end

      def approved?
        state == :APPROVED
      end

      def changes_requested?
        state == :CHANGES_REQUESTED
      end

      def commented?
        state == :COMMENTED
      end

      def dot
        dot_status[state]
      end

      private

      attr_reader :review

      def dot_status
        @dot_status ||= {
          APPROVED: pastel.green('^'),
          CHANGES_REQUESTED: pastel.red('X'),
          COMMENTED: '?'
        }
      end

      def pastel
        @pastel ||= Pastel.new
      end
    end
  end
end
