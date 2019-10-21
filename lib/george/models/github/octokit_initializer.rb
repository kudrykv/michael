# frozen_string_literal: true

require 'octokit'

require_relative '../configuration'

class OctokitInitializer
  attr_reader :octokit

  def initialize
    token = Configuration.fetch(:token)

    @octokit = Octokit::Client.new(access_token: token)
    @octokit.auto_paginate = true
  end
end