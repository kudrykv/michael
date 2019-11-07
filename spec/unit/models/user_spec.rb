# frozen_string_literal: true

require 'michael/models/user'

RSpec.describe Michael::Models::User do
  let(:login) { 'barbara' }
  let(:raw_user) { { login: login } }

  context :username do
    it 'should get username' do
      user = Michael::Models::User.new(raw_user)
      expect(user.username).to eq(login)
    end
  end
end
