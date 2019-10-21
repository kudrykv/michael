# frozen_string_literal: true

require 'george/commands/auth'

RSpec.describe George::Commands::Auth do
  it 'executes `auth` command successfully' do
    prompt = double(:prompt)
    allow(prompt)
      .to receive(:mask)
      .with('Please specify github token:', echo: false)
      .and_return('lala')

    output = StringIO.new
    command = George::Commands::Auth.new(prompt, {})

    command.execute(output: output)

    # expect(output.string).to eq("OK\n")
  end
end
