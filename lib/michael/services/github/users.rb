# frozen_string_literal: true

require_relative 'initializer'
require 'michael/models/user'

module Michael
  module Services
    module Github
      class Users < Initializer
        def user
          Michael::Models::User.new(octokit.user)
        end
      end
    end
  end
end
