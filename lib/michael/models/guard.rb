# frozen_string_literal: true

require_relative '../command'
require_relative 'github/token_validator'

module Michael
  module Models
    class Guard < Michael::Command
      attr_reader :config, :repos_config

      def initialize
        @config = Configuration.new
        @repos_config = Configuration.new(config_name: 'repositories')

        token_valid = Github::TokenValidator.token_valid?(config.fetch(:token))
        abort 'Your token is invalid' unless token_valid
      end
    end
  end
end