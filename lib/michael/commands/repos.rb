# frozen_string_literal: true

require 'thor'
require 'tty-editor'

require 'michael/constants'
require 'michael/services/github/users'
require 'michael/services/configuration'
require 'michael/services/github/token'
require 'michael/services/github/pull_requests'
require 'michael/services/repositories'

module Michael
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
          ttycfg = TTY::Config.new
          ttycfg.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfg.filename = Michael::CONFIG_FILENAME

          ttycfgrepos = TTY::Config.new
          ttycfgrepos.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfgrepos.filename = Michael::CONFIG_REPOS_FILENAME

          cfg = Michael::Services::Configuration.new(ttycfg)
          repocfg = Michael::Services::Configuration.new(ttycfgrepos)

          token = Michael::Services::Github::Token.new(cfg)
          token.validate(cfg.fetch(:token))

          repos_filepath = Michael::CONFIG_DIR_ABSOLUTE_PATH + '/' + Michael::CONFIG_REPOS_FILENAME + '.yml'
          Michael::Commands::Repos::Edit.new(repos_filepath, repocfg, TTY::Editor, options).execute
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
          ttycfgrepos = TTY::Config.new
          ttycfgrepos.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfgrepos.filename = Michael::CONFIG_REPOS_FILENAME

          ttycfgtkn = TTY::Config.new
          ttycfgtkn.append_path(Michael::CONFIG_DIR_ABSOLUTE_PATH)
          ttycfgtkn.filename = Michael::CONFIG_FILENAME

          repocfg = Michael::Services::Configuration.new(ttycfgrepos)
          tkncfg = Michael::Services::Configuration.new(ttycfgtkn)

          prs = Michael::Services::Github::PullRequests.new(tkncfg)
          users = Michael::Services::Github::Users.new(tkncfg)
          repos = Michael::Services::Repositories.new(prs)
          Michael::Commands::Repos::PullRequests.new(repocfg, users, repos, options).execute
        end
      end
    end
  end
end
