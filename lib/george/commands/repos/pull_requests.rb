# frozen_string_literal: true

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
          @repos = config.fetch(:repos)
          @options = options
        end

        def execute(out: $stdout)
          hsh = prs.search_many(repos)

          print_good_prs(out, repos_with_prs(hsh[:repos]))
          print_repos_w_no_prs(out, repos_no_prs(hsh[:repos]))
          print_broken_repos(out, hsh[:broken])
        end

        private

        attr_reader :prs, :options, :repos

        def repos_no_prs(list_all)
          list_all.select { |item| item[:prs].empty? }.map { |item| item[:repo] }
        end

        def repos_with_prs(list_all)
          list_all
            .reject { |item| item[:prs].empty? }
            .map { |item| RepositoryFormatter.new(item[:repo], item[:prs]).pretty }
        end

        def print_good_prs(out, list)
          out.puts list.join("\n\n")
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
