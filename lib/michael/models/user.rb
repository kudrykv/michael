# frozen_string_literal: true

module Michael
  module Models
    class User
      def initialize(user)
        @user = user
      end

      def username
        user[:login]
      end

      private
      attr_reader :user
    end
  end
end
