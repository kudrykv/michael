# frozen_string_literal: true

require 'octokit'

module Michael
  module Services
    module Github
      class Initializer
        attr_reader :octokit

        def initialize(token)
          @octokit = Octokit::Client.new(access_token: token)
        end
      end
    end
  end
end
