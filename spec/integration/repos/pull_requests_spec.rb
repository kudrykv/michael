# frozen_string_literal: true

RSpec.describe '`michael repos prs` command', type: :cli do
  it 'executes `michael repos help prs` command successfully' do
    output = `michael repos help prs`
    expected_output = <<~OUT
      Usage:
        michael prs

      Options:
        -h, [--help], [--no-help]  # Display usage information

      Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
