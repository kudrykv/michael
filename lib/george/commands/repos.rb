# frozen_string_literal: true

require 'thor'

module George
  module Commands
    class Repos < Thor
      namespace :repos

      desc 'edit', 'Edit list of repos to follow'
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

      desc 'prs', 'List open PRs'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :show_empty, aliases: '-e', type: :boolean, default: false,
                                 desc: 'List watched repos that have no open PRs'
      method_option :skip_self, aliases: '-s', type: :boolean,
                                desc: 'Skip PRs created by the current user'
      def prs(*)
        if options[:help]
          invoke :help, ['prs']
        else
          begin
            require_relative 'repos/pull_requests'
            George::Commands::Repos::PullRequests.new(options).execute
          rescue StandardError
            abort 'interrupted'
          end
        end
      end
    end
  end
end
