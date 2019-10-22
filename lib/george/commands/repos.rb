# frozen_string_literal: true

require 'thor'

module George
  module Commands
    class Repos < Thor
      namespace :repos

      desc 'edit', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def edit(*)
        if options[:help]
          invoke :help, ['edit']
        else
          require_relative 'repos/edit'
          George::Commands::Repos::Edit.new(options).execute
        end
      end

      desc 'prs', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def prs(*)
        if options[:help]
          invoke :help, ['prs']
        else
          begin
          require_relative 'repos/pull_requests'
          George::Commands::Repos::PullRequests.new(options).execute
          rescue
            abort 'interrupted'
          end
        end
      end
    end
  end
end
