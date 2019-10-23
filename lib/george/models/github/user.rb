# frozen_string_literal: true

require_relative 'octokit_initializer'

class User < OctokitInitializer
  def username
    me[:login]
  end

  private

  def me
    @me ||= octokit.user
  end
end
