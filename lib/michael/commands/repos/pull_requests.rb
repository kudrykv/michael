# frozen_string_literal: true

require 'parallel'

require_relative '../../command'

module Michael
  module Commands
    class Repos
      class PullRequests
        attr_reader :config, :users, :repos, :options

        def initialize(config, users, repos, options)
          @config = config
          @users = users
          @repos = repos
          @options = options
        end

        def execute
          q = Queue.new
          waiting = print_waiting(q)
          list = config.fetch(:repos)

          list = repos.pull_requests(list, q)
          waiting.join

          puts [filter_repos_w_prs(list), get_empty(list), get_broken(list)]
            .reject(&:nil?).join("\n\n")
        end

        private

        def filter_repos_w_prs(list)
          list.each do |r|
            r.prs.reject! { |pr| pr.author?(users.user.username) } if options[:skip_self]
            r.prs.reject!(&:approved?) if options[:hide_approved]
            r.prs.select!(&:needs_review?) if options[:needs_review]
            r.prs.select! { |pr| pr.actionable?(users.user.username) } if options[:actionable]
          end

          list.select(&:has_prs?).map!(&:pretty_print).join("\n\n")
        end

        def get_broken(list)
          broken = list.select(&:broken?)
          return nil if broken.none?

          'Broken repos: ' + broken.map(&:pretty_print).join(', ')
        end

        def get_empty(list)
          return nil unless options[:show_empty]

          empty = list.reject(&:has_prs?)
          return nil if empty.none?

          'No PRs: ' + empty.map(&:pretty_print).join(', ')
        end

        def print_waiting(queue)
          Thread.new do
            until queue.closed?
              queue.pop
              print '.'
              $stdout.flush
            end

            puts
          end
        end
      end
    end
  end
end
