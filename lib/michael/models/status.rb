# frozen_string_literal: true

require 'pastel'

module Michael
  module Models
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

      def dot
        dot_status[state]
      end

      private

      attr_reader :status

      def dot_status
        @dot_status ||= {
          success: pastel.green('+'),
          pending: pastel.yellow('.'),
          error: pastel.red('x'),
          failure: pastel.red('x')
        }
      end

      def pastel
        @pastel ||= Pastel.new
      end
    end
  end
end
