# frozen_string_literal: true

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

      def ==(other)
        org_name == other.org_name &&
          prs == other.prs
      end
    end
  end
end
