# frozen_string_literal: true

require_relative '../../command'
require_relative 'token_validator'

class Guard < George::Command
  attr_reader :config

  def initialize
    @config = Configuration.new

    token_valid = TokenValidator.token_valid?(config.fetch(:token))
    abort 'Your token is invalid' unless token_valid

  end
end
