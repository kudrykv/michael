# frozen_string_literal: true

require 'tty-prompt'

require_relative '../command'
require_relative '../models/github/token_validator'

module George
  module Commands
    class Auth < George::Command
      attr_reader :prompt

      def initialize(options)
        @prompt = TTY::Prompt.new
        @options = options
      end

      def execute(out: $stdout)
        token = read_token
        unless TokenValidator.token_valid?(token)
          return out.puts 'Specified token is invalid'
        end

        unless TokenValidator.save_token(token)
          return out.puts 'Failed to save the token'
        end

        out.puts 'Token saved'
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
