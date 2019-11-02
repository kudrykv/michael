# frozen_string_literal: true

require 'octokit'

module Michael
  module Services
    class Token
      def initialize(config)
        raise Error, 'config is nil' if config.nil?

        @config = config
      end

      def validate(token)
        raise Error, 'access token must contain `repo` scope' unless scopes(token).include?('repo')
      end

      def store(token)
        config.set(:token, value: token)
      end

      private

      attr_reader :config

      def scopes(token)
        Octokit.new(access_token: token).scopes
      rescue Error
        raise Error, 'invalid access token'
      end
    end
  end
end
