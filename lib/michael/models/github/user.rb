# frozen_string_literal: true

require_relative 'octokit_initializer'

module Michael
  module Models
    module Github
      class User < OctokitInitializer
        def username
          me[:login]
        end

        private

        def me
          @me ||= octokit.user
        end
      end
    end
  end
end