# frozen_string_literal: true

require 'thor'
require 'tty-prompt'
require 'tty-config'

require_relative 'constants'
require_relative 'services/token'

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
        config = TTY::Config.new
        config.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
        config.filename = Michael::CONFIG_FILENAME

        token = Michael::Services::Token.new(config)

        Michael::Commands::Auth.new(TTY::Prompt.new, token, options).execute
      end
    end
  end
end
