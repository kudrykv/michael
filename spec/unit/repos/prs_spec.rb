require 'george/commands/repos/prs'

RSpec.describe George::Commands::Repos::Prs do
  it "executes `repos prs` command successfully" do
    output = StringIO.new
    options = {}
    command = George::Commands::Repos::Prs.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
