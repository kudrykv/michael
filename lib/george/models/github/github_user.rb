# frozen_string_literal: true

require_relative 'octokit_initializer'

class GithubUser < OctokitInitializer
  def user
    octokit.user
  end
end
