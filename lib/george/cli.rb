# frozen_string_literal: true

require 'thor'
require 'tty-prompt'

require_relative 'models/github/token_validator'
require_relative 'models/configuration'

module George
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'george version'

    def version
      require_relative 'version'
      puts "v#{George::VERSION}"
    end

    map %w[--version -v] => :version

    desc 'auth', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def auth(*)
      if options[:help]
        invoke :help, ['auth']
      else
        require_relative 'commands/auth'
        George::Commands::Auth.new(prompt, TokenValidator.new, options).execute
      end
    end

    private

    def prompt
      TTY::Prompt.new
    end
  end
end
