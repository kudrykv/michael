# frozen_string_literal: true

require 'pastel'

module Michael
  module Models
    class Repository
      attr_reader :org_name, :prs

      def initialize(org_name, prs: nil)
        @org_name = org_name
        @prs = prs
      end

      def broken?
        prs.nil?
      end

      def has_prs?
        !broken? && prs.any?
      end

      def ==(other)
        org_name == other.org_name &&
          prs == other.prs
      end

      def pretty_print
        return pastel.black.on_red(org_name) if broken?

        [
          pastel.bold(org_name + ':'),
          prs.map(&:pretty_print).join("\n")
        ].join("\n")
      end

      private

      def pastel
        @pastel ||= Pastel.new
      end
    end
  end
end
