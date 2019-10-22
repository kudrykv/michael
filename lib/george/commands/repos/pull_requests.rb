# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/github/pull_request'
require_relative '../../models/github/guard'

module George
  module Commands
    class Repos
      class PullRequests < Guard
        attr_reader :prs, :options, :repos

        def initialize(options)
          super()

          @prs = PullRequest.new
          @repos = config.fetch(:repos)
          @options = options
        end

        def execute(out: $stdout)
          repos_wo_opened_prs = []
          bad_repos = []
          fine_repos = repos.map do |repo|
            list = prs.search(repo)
            unless list
              bad_repos.push(repo)
              next
            end

            processed_prs = process_prs(repo, list)
            if processed_prs.empty?
              repos_wo_opened_prs.push(repo)
              next
            end

            { repo: repo, prs: processed_prs }
          end

          print_good_prs(out, fine_repos.reject(&:nil?))
          print_repos_w_no_prs(out, repos_wo_opened_prs)
          print_broken_repos(out, bad_repos)
        end

        private

        def print_good_prs(out, list)
          list = list.map do |rwpr|
            [
              pastel.bold(rwpr[:repo] + ':'),
              rwpr[:prs].join("\n")
            ].join("\n")
          end

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

        def process_prs(repo, list)
          list.map { |pr| process_single_pr(repo, pr) }
        end

        def process_single_pr(repo, pr)
          reviewed_by = pr_review_statuses(prs.reviews(repo, pr.number))
          statuses = prs.statuses(repo, pr.head_sha)[:statuses]

          info_about_pr(pr, reviewed_by, statuses)
        end

        def info_about_pr(pr, reviews, statuses)
          format(
            '#%<number>s %<statuses_in_dots>s %<reviews_in_dots>s %<title>s %<postfix>s',
            number: pastel.bold(pr.number),
            statuses_in_dots: statuses_to_dots(statuses).join,
            reviews_in_dots: reviews_to_dots(pr, reviews).join,
            title: pr.title,
            postfix: postfix_line_stringified(pr, reviews)
          )
        end

        def statuses_to_dots(statuses)
          statuses.map { |status| dot_status[status[:state].to_sym] }
        end

        def reviews_to_dots(pr, reviews)
          return [pastel.red('.')] unless pr.reviewed? || reviews.any?
          return [pastel.yellow('.')] if reviews.empty?

          reviews
            .reject { |review| review.author == pr.author }
            .map { |review| dot_status[review.state.to_sym] }
        end

        def postfix_line_stringified(pr, reviews)
          [
            labels_stringified(pr.labels),
            pastel.cyan(pr.author),
            who_req_changes_stringified(requested_changes(reviews)),
            who_commented_stringified(commented_on_pr(pr, reviews))
          ].reject(&:empty?).join(' ')
        end

        def requested_changes(reviews)
          reviews.select(&:changes_requested?).map(&:author)
        end

        def who_commented_stringified(names)
          return '' if names.empty?

          '| Commented: ' + names.join(', ')
        end

        def who_req_changes_stringified(names)
          return '' if names.empty?

          '| ' + pastel.bold('Requested changes: ') << names.map { |name| pastel.underscore(name) }.join(', ')
        end

        def commented_on_pr(pr, reviews)
          reviews
            .reject { |review| pr.author == review.author }
            .select(&:commented?).map(&:author)
        end

        def pr_review_statuses(people_reviews)
          sorted = people_reviews.sort_by(&:author)

          group_reviews_by_user(sorted)
            .map { |reviews| reviews.sort_by(&:submitted_at).reverse.first }
        end

        def group_reviews_by_user(sorted_reviews)
          sorted_reviews.each_with_object [] do |review, acc|
            if acc.empty?
              acc.push [review]
              next
            end

            prev = acc.length - 1
            if acc[prev][0].author == review.author
              acc[prev].push(review)
            else
              acc.push([review])
            end

            acc
          end
        end

        def labels_stringified(labels)
          return '' if labels.empty?

          pastel.bold.yellow("[#{labels.join(', ')}]")
        end

        def login(obj)
          obj[:user][:login]
        end

        def dot_status
          @dot_status ||= {
            success: pastel.green('+'),
            pending: pastel.yellow('.'),
            error: pastel.red('x'),
            failure: pastel.red('x'),
            APPROVED: pastel.green('^'),
            CHANGES_REQUESTED: pastel.red('X'),
            COMMENTED: '-'
          }
        end
      end
    end
  end
end
