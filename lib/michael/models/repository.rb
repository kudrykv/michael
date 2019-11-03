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
    end
  end
end
