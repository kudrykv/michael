# frozen_string_literal: true

require_relative '../command'

module Michael
  module Commands
    class Auth
      def initialize(prompt, token, options)
        @prompt = prompt
        @token = token
        @options = options
      end

      def execute
        tkn = read_token
        token.validate(tkn)
        token.store(tkn)
        puts 'Token saved!'
      end

      private

      attr_reader :prompt, :token, :options

      def read_token
        prompt.mask('Please specify github token:', echo: false) do |q|
          q.modify :strip
        end
      end
    end
  end
end
