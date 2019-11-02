# frozen_string_literal: true

require 'octokit'

require_relative '../../../michael'

module Michael
  module Services
    module Github
      class Token
        def initialize(config)
          raise Michael::Error, 'config is nil' if config.nil?

          @config = config
        end

        def validate(token)
          raise Michael::Error, 'access token must contain `repo` scope' unless scopes(token).include?('repo')
        end

        def store(token)
          config.set(:token, value: token)
        end

        def token
          config.fetch(:token)
        end

        private

        attr_reader :config

        def scopes(token)
          Octokit::Client.new(access_token: token).scopes
        rescue Octokit::Unauthorized
          raise Michael::Error, 'invalid access token'
        end
      end
    end
  end
end
