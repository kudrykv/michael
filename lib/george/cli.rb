# frozen_string_literal: true

require 'thor'

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

    require_relative 'commands/repos'
    register George::Commands::Repos,
             'repos',
             'repos [SUBCOMMAND]',
             'Follow repositories and list opened PRs'

    desc 'auth', 'Authorize george with github API token'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'

    def auth(*)
      if options[:help]
        invoke :help, ['auth']
      else
        require_relative 'commands/auth'
        George::Commands::Auth.new(options).execute
      end
    end
  end
end
