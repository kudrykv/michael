# frozen_string_literal: true

require 'michael/services/repositories'

RSpec.describe Michael::Services::Repositories do
  let(:prs) { double(:prs) }

  context :initialize do
    it 'should create an object' do
      expect { Michael::Services::Repositories.new(false) }.not_to raise_error
    end

    it 'should raise a fatal when param is uninitialized' do
      expect { Michael::Services::Repositories.new(nil) }.to raise_error(Michael::Fatal)
    end
  end

  context :pull_requests do
    let(:repolist) { ['org/repo'] }
    let(:resplist) { [[]] }
    let(:resprepo) { Michael::Models::Repository.new('org/repo', broken:  false, prs: []) }
    let(:params) { {} }
    let(:repos) { Michael::Services::Repositories.new(prs) }

    it 'should list repos and its PRs' do
      repolist.zip(resplist).each do |r, o|
        allow(prs).to receive(:search).with(r, params).and_return(o)
      end

      list = repos.pull_requests(repolist)
      expect(list).to contain_exactly(resprepo)
    end
  end
end
