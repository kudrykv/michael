# frozen_string_literal: true

require 'parallel'

require_relative '../../command'
require_relative '../../models/github/pull_request'
require_relative '../../models/guard'
require_relative '../../models/pull_request_formatter'
require_relative '../../models/repository_formatter'

module George
  module Commands
    class Repos
      class PullRequests < Guard
        def initialize(options)
          super()

          @prs = PullRequest.new
          @repos = repos_config.fetch(:repos)
          abort 'No repositories configured' if @repos.nil? || @repos.empty?

          @options = options
        end

        def execute(out: $stdout)
          list = get_repos_with_spinner(out)

          print_good_prs(out, repos_with_prs(list))
          print_repos_w_no_prs(out, repos_no_prs(list))
          print_broken_repos(out, list.select { |item| item[:state] == :failed })
        end

        private

        attr_reader :prs, :options, :repos

        def get_repos_with_spinner(out)
          progress = 0
          spin = spinner(
            "[:spinner] :progress/#{repos.length} processing...",
            output: out
          )

          spin.update(progress: 0)

          result = Parallel.map(repos, in_threads: 5) do |repo|
            progress += 1
            spin.update(progress: progress)
            spin.spin
            out = prs.process_repo(repo)
            spin.spin
            out
          end

          spin.stop('done')

          result
        end

        def repos_no_prs(list_all)
          list_all
            .select { |item| item[:state] == :success && item[:prs].empty? }
            .map { |item| item[:repo] }
        end

        def repos_with_prs(list_all)
          list_all
            .select { |item| item[:state] == :success && item[:prs].any? }
            .map { |item| RepositoryFormatter.new(item[:repo], item[:prs]).pretty }
        end

        def print_good_prs(out, list)
          out.puts "\n" + list.join("\n\n")
        end

        def print_repos_w_no_prs(out, list)
          out.puts "\nRepos with no opened PRs: #{list.join(', ')}" if list.any?
        end

        def print_broken_repos(out, list)
          return if list.empty?

          list = list.map { |repo| pastel.on_red.black(repo) }
          out.puts "\nBad repos: #{list.join(', ')}"
        end
      end
    end
  end
end
