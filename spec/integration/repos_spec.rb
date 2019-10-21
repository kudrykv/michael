# frozen_string_literal: true

RSpec.describe '`george repos` command', type: :cli do
  it 'executes `george help repos` command successfully' do
    output = `george help repos`
    expected_output = <<~OUT
      Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
