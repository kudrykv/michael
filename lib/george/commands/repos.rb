# frozen_string_literal: true

require 'thor'

module George
  module Commands
    class Repos < Thor

      namespace :repos

      desc 'prs', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def prs(*)
        if options[:help]
          invoke :help, ['prs']
        else
          require_relative 'repos/pull_requests'
          George::Commands::Repos::PullRequests.new(options).execute
        end
      end
    end
  end
end
