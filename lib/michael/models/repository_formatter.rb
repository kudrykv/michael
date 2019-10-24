# frozen_string_literal: true

require_relative 'pull_request_formatter'

module Michael
  module Models
    class RepositoryFormatter
      def initialize(reponame, prs)
        @reponame = reponame
        @prs = prs
        @pastel = Pastel.new
      end

      def pretty
        [
          pastel.bold(reponame + ':'),
          prs.map { |pr| PullRequestFormatter.new(pr).pretty }.join("\n")
        ].join("\n")
      end

      private

      attr_reader :reponame, :prs, :pastel
    end
  end
end