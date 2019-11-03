# frozen_string_literal: true

require 'parallel'

require_relative '../models/repository'

module Michael
  module Services
    class Repositories
      def initialize(prs, threads = 5)
        raise Fatal, 'uninitialized prs' if prs.nil?

        @prs = prs
        @threads = threads
      end

      def pull_requests(org_repos_list, queue = nil, params = {})
        repos = Parallel.map(org_repos_list, in_threads: threads) do |org_repo|
          queue << org_repo unless queue.nil?
          list = prs.search(org_repo, params)
          Michael::Models::Repository.new(org_repo, prs: list)
        end

        queue&.close

        repos
      end

      private

      attr_reader :prs, :threads
    end
  end
end
