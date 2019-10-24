# frozen_string_literal: true

RSpec.describe '`michael repos` command', type: :cli do
  it 'executes `michael help repos` command successfully' do
    output = `michael help repos`
    expected_output = <<~OUT
      Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
