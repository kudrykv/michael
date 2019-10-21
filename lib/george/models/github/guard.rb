# frozen_string_literal: true

require_relative '../../command'
require_relative 'octokit_initializer'

class Guard < George::Command
  attr_reader :octokit

  def initialize
    token_valid = TokenValidator.token_valid? Configuration.fetch(:token)
    abort 'Your token is invalid' if token_valid

    @octokit = OctokitInitializer.new
  end
end
