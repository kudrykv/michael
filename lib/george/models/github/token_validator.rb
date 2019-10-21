# frozen_string_literal: true

require 'octokit'

class TokenValidator
  def token_valid?(token)
    Octokit::Client.new(access_token: token).user
    true
  rescue StandardError
    false
  end

  def save_token(token)
    Configuration.new.set(:token, value: token)
  end
end
