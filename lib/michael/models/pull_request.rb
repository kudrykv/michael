# frozen_string_literal: true

require 'pastel'
require 'ruby-duration'

module Michael
  module Models
    class PullRequest
      attr_reader :pull_request
      attr_accessor :statuses, :reviews, :comments

      def initialize(pull_request)
        @pull_request = pull_request
      end

      def number
        pull_request[:number]
      end

      def title
        pull_request[:title]
      end

      def author
        pull_request[:user][:login]
      end

      def head_sha
        pull_request[:head][:sha]
      end

      def labels
        pull_request[:labels].map(&:name)
      end

      def approved?
        reviews.any? && reviews.all?(&:approved?)
      end

      def needs_review?
        pull_request[:requested_reviewers].any? || pull_request[:requested_teams].any?
      end

      def author?(name)
        author == name
      end

      def actionable?(name)
        return false if author?(name)
        return true if reviews.map(&:author).none?(name)

        last_update_head?
      end

      def pretty_print
        [
          pastel.bold("\##{number}"),
          statuses_in_dots,
          reviews_in_dots,
          title,
          labels.empty? ? nil : pastel.bold.yellow("[#{labels.join(', ')}]"),
          pastel.cyan(author),
          pretty_last_update(Time.now, last_updated_at),
          requested_changes,
          commented
        ].reject(&:nil?).join(' ')
      end

      private

      def last_updated_at
        updates = [pull_request[:updated_at]]
        updates.concat(statuses.map(&:updated_at)) if !statuses.nil? && statuses.any?
        updates.concat(reviews.map(&:submitted_at)) if !reviews.nil? && reviews.any?

        updates.sort.pop
      end

      def statuses_in_dots
        return nil if statuses.nil?
        return '-' if statuses.empty?

        statuses.map(&:dot).join
      end

      def reviews_in_dots
        return nil if reviews.nil?
        return '-' if !needs_review? && reviews.none?
        return pastel.yellow('.') if reviews.empty?

        reviews.map(&:dot).join
      end

      def requested_changes
        rc = reviews.select(&:changes_requested?).map(&:author)
        return nil if rc.empty?

        '| ' + pastel.bold('Requested changes: ') + rc.map { |n| pastel.underscore(n) }.join(', ')
      end

      def commented
        rc = reviews.select(&:commented?).map(&:author)
        return nil if rc.empty?

        '| Commented: ' + rc.join(', ')
      end

      def pretty_last_update(bigger, smaller)
        duration = Duration.new(bigger-smaller)

        wh = if duration.weeks.positive?
          pastel.yellow.bold("#{duration.weeks} week(s)")
        elsif duration.days.positive?
          pastel.yellow("#{duration.days} day(s)")
        elsif duration.hours.positive?
          "#{duration.hours} hour(s)"
        elsif duration.minutes.positive?
          "#{duration.minutes} minute(s)"
        else
          'seconds'
             end

        "last update #{wh} ago"
      end

      def last_update_head?
        updated_at = pull_request[:updated_at]
        reviewed_at = reviews.map(&:submitted_at).sort.pop
        updated_at > reviewed_at
      end

      def pastel
        @pastel ||= Pastel.new
      end
    end
  end
end
