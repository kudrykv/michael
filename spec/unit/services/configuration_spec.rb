# frozen_string_literal: true

require 'tty-config'

require 'michael/services/configuration'

RSpec.describe Michael::Services::Configuration do
  config = TTY::Config.new
  config.append_path('./test')
  config.filename = 'testconfig'

  cfg = Michael::Services::Configuration.new(config)

  context 'configuration is initialized' do
    it 'should set key' do
      cfg.set(:key, value: 1)
      expect(cfg.fetch(:key)).to eq(1)
    end

    it 'should fetch a key' do
      cfg.set(:list, value: 1)
      cfg.append(2, to: :list)
      expect(cfg.fetch(:list)).to contain_exactly(1, 2)
    end

    it 'should remove the value from the list' do
      cfg.set(:list, value: 1)
      cfg.append(2, to: :list)
      cfg.remove(1, from: :list)
      expect(cfg.fetch(:list)).to contain_exactly(2)
    end
  end
end
