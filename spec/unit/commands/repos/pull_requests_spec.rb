# frozen_string_literal: true

require 'michael/commands/repos/pull_requests'

RSpec.describe Michael::Commands::Repos::PullRequests do
  it 'executes `repos prs` command successfully' do
    output = StringIO.new
    options = {}
    command = Michael::Commands::Repos::PullRequests.new(options)

    command.execute(out: output)

    expect(output.string).to eq("OK\n")
  end
end
