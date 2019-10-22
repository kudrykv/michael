# frozen_string_literal: true

require 'george/commands/repos/pull_requests'

RSpec.describe George::Commands::Repos::PullRequests do
  it 'executes `repos prs` command successfully' do
    output = StringIO.new
    options = {}
    command = George::Commands::Repos::PullRequests.new(options)

    command.execute(out: output)

    expect(output.string).to eq("OK\n")
  end
end
