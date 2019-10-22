# frozen_string_literal: true

RSpec.describe '`george repos prs` command', type: :cli do
  it 'executes `george repos help prs` command successfully' do
    output = `george repos help prs`
    expected_output = <<~OUT
      Usage:
        george prs

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
