# frozen_string_literal: true

require 'octokit'

require_relative '../configuration'

module Michael
  module Models
    module Github
      class OctokitInitializer
        attr_reader :octokit

        def initialize
          token = Configuration.new.fetch(:token)
          @octokit = Octokit::Client.new(access_token: token)
          @octokit.auto_paginate = true
        end
      end
    end
  end
end