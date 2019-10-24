# frozen_string_literal: true

require 'michael/commands/auth'

RSpec.describe Michael::Commands::Auth do
  let(:prompt) { double(:prompt) }
  let(:validator) { double(:validator) }

  context 'when everything goes according to the plan' do
    it 'should execute `auth` command successfully' do
      allow(prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:mask)
        .with('Please specify github token:', echo: false)
        .and_return('token')

      allow(validator).to receive(:token_valid?)
        .with('token').and_return(true)

      allow(validator).to receive(:save_token)
        .with('token').and_return(true)

      stub_const('TTY::Prompt', prompt)
      stub_const('Michael::Models::Github::TokenValidator', validator)

      output = StringIO.new
      command = Michael::Commands::Auth.new({})

      command.execute(out: output)

      expect(output.string).to eq("Token saved\n")
    end
  end

  context 'token is invalid' do
    it 'should tell that the token is invalid' do
      allow(prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:mask)
        .with('Please specify github token:', echo: false)
        .and_return('invalid')

      allow(validator).to receive(:token_valid?)
        .with('invalid')
        .and_return(false)

      stub_const('TTY::Prompt', prompt)
      stub_const('TokenValidator', validator)

      output = StringIO.new
      command = Michael::Commands::Auth.new({})

      command.execute(out: output)

      expect(output.string).to eq("Specified token is invalid\n")
    end
  end

  context 'something is wrong with disk or IO' do
    it 'should tell it failed to save it' do
      allow(prompt).to receive(:new).and_return(prompt)
      allow(prompt).to receive(:mask)
        .with('Please specify github token:', echo: false)
        .and_return('token')

      allow(validator).to receive(:token_valid?)
        .with('token')
        .and_return(true)

      allow(validator).to receive(:save_token)
        .with('token')
        .and_return(false)

      stub_const('TTY::Prompt', prompt)
      stub_const('Michael::Models::Github::TokenValidator', validator)

      output = StringIO.new
      command = Michael::Commands::Auth.new({})

      command.execute(out: output)

      expect(output.string).to eq("Failed to save the token\n")
    end
  end
end
