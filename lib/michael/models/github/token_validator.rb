# frozen_string_literal: true

require 'octokit'

require_relative '../configuration'

module Michael
  module Models
    module Github
      class TokenValidator
        class << self
          def token_valid?(token)
            scopes = Octokit::Client.new(access_token: token).scopes

            return true if scopes.include?('repo')

            puts 'Token should have `repo` scope'
            false
          rescue StandardError
            false
          end

          def save_token(token)
            Configuration.new.set(:token, value: token)
          end
        end
      end
    end
  end
end