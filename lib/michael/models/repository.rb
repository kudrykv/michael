# frozen_string_literal: true

module Michael
  module Models
    class Repository
      attr_reader :org_name, :broken, :prs

      def initialize(org_name, broken: false, prs: [])
        @org_name = org_name
        @broken = broken
        @prs = prs
      end

      def ==(other)
        org_name == other.org_name &&
          broken == other.broken &&
          prs == other.prs
      end
    end
  end
end
