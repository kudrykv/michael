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
          print_waiting(q)
          list = config.fetch(:repos)

          list = repos.pull_requests(list, q).select(&:has_prs?)

          puts list.map(&:pretty_print).join("\n\n")
        end

        private

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
