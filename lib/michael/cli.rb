# frozen_string_literal: true

require 'thor'

module Michael
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'michael version'

    def version
      require_relative 'version'
      puts "v#{Michael::VERSION}"
    end

    map %w[--version -v] => :version

    desc 'auth2', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def auth2(*)
      if options[:help]
        invoke :help, ['auth2']
      else
        require_relative 'commands/auth2'
        Michael::Commands::Auth2.new(options).execute
      end
    end

    require_relative 'commands/repos'
    register Michael::Commands::Repos,
             'repos',
             'repos [SUBCOMMAND]',
             'Follow repositories and list opened PRs'

    desc 'auth', 'Authorize michael with github API token'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def auth(*)
      if options[:help]
        invoke :help, ['auth']
      else
        require_relative 'commands/auth'
        Michael::Commands::Auth.new(options).execute
      end
    end
  end
end
