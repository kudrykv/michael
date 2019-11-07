# frozen_string_literal: true

require 'pastel'
require 'michael/models/status'

RSpec.describe Michael::Models::Status do
  let(:pastel) { Pastel.new(enabled: true) }
  let(:success_state) { 'success' }
  let(:updated_at) { Time.now }
  let(:raw) { { state: success_state, updated_at: updated_at } }
  let(:status) { Michael::Models::Status.new(raw, pastel_params: { enabled: true }) }

  describe :state do
    it 'should return state' do
      expect(status.state).to eq(success_state.to_sym)
    end
  end

  describe :updated_at do
    it 'should return its updated at' do
      expect(status.updated_at).to eq(updated_at)
    end
  end

  describe :dot do
    context 'when the state is successful' do
      let(:raw) { { state: success_state } }
      let(:status) { Michael::Models::Status.new(raw, pastel_params: { enabled: true }) }

      it 'should be green plus' do
        expect(status.dot).to eq(pastel.green('+'))
      end
    end
  end
end
