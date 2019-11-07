# frozen_string_literal: true

require 'michael/models/repository'

RSpec.describe Michael::Models::Repository do
  R = Michael::Models::Repository
  let(:org_name) { 'org/name' }

  context :org_name do
    it 'should return org name' do
      repo = R.new(org_name)
      expect(repo.org_name).to eql(org_name)
    end
  end

  context :broken? do
    it 'should say it is broken when there is name only' do
      repo = R.new(org_name)
      expect(repo.broken?).to be_truthy
    end

    it 'should say it is fine when prs is a list' do
      repo = R.new(org_name, prs: [])
      expect(repo.broken?).to be_falsey
    end
  end

  context :has_prs? do
    context 'when the repo is broken' do
      it 'should say the repo has no prs' do
        repo = R.new(org_name)
        expect(repo.has_prs?).to be_falsey
      end
    end

    context 'when there are no prs' do
      it 'should should say the repo has no prs' do
        repo = R.new(org_name, prs: [])
        expect(repo.has_prs?).to be_falsey
      end
    end
  end
end
