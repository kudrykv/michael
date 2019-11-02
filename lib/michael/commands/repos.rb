# frozen_string_literal: true

require 'thor'

require_relative '../constants'
require_relative '../services/configuration'
require_relative '../services/token'
require_relative '../services/github/pull_requests'

module Michael
  module Commands
    class Repos < Thor
      namespace :repos

      desc 'pr2', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def pr2(*)
        if options[:help]
          invoke :help, ['pr2']
        else
          require_relative 'repos/pr2'
          ttycfg = TTY::Config.new
          ttycfg.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfg.filename = Michael::CONFIG_REPOS_FILENAME

          cfg = Michael::Services::Configuration.new(ttycfg)

          prs = Michael::Services::Github::PullRequests.new(cfg.fetch(:token))

          Michael::Commands::Repos::Pr2.new(cfg, prs, options).execute
        end
      end

      desc 'edit', 'Edit list of repos to follow'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def edit(*)
        if options[:help]
          invoke :help, ['edit']
        else
          require_relative 'repos/edit'
          ttycfg = TTY::Config.new
          ttycfg.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfg.filename = Michael::CONFIG_FILENAME

          cfg = Michael::Services::Configuration.new(ttycfg)

          token = Michael::Services::Token.new(cfg)
          token.validate(cfg.fetch(:token))

          Michael::Commands::Repos::Edit.new(options).execute
        end
      end

      desc 'prs', 'List open PRs'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      method_option :show_empty, aliases: '-e', type: :boolean,
                                 desc: 'List watched repos that have no open PRs'
      method_option :skip_self, aliases: '-s', type: :boolean,
                                desc: 'Skip PRs created by the current user'
      method_option :hide_approved, aliases: '-p', type: :boolean,
                                    desc: 'Hide PRs that are approved and have'\
                                          ' no requests for changes'
      method_option :needs_review, aliases: '-n', type: :boolean,
                                   desc: 'Show only ones which do not have any '\
                                         'reviews yet'
      method_option :actionable, aliases: '-t', type: :boolean,
                                 desc: 'List only actionable PRs. These are '\
      'PRs which you did not review yet, or ones which were updated after '\
      'your review'
      def prs(*)
        if options[:help]
          invoke :help, ['prs']
        else
          require_relative 'repos/pull_requests'
          Michael::Commands::Repos::PullRequests.new(options).execute
        end
      end
    end
  end
end
