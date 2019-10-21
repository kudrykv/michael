# frozen_string_literal: true

require_relative '../command'

module George
  module Commands
    class Auth < George::Command
      attr_reader :prompt, :validator

      def initialize(prompt, validator, options)
        @prompt = prompt
        @validator = validator
        @options = options
      end

      def execute(o: $stdout)
        token = read_token
        unless validator.token_valid?(token)
          return o.puts 'Specified token is invalid'
        end

        return o.puts 'Failed to save token' unless validator.save_token(token)

        o.puts 'Token saved'
      end

      private

      def read_token
        prompt.mask('Please specify github token:', echo: false) do |q|
          q.modify :strip
        end
      end
    end
  end
end
