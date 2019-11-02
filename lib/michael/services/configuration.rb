# frozen_string_literal: true

require 'tty-config'

require_relative '../constants'

module Michael
  module Services
    class Configuration
      def initialize(config)
        raise Error('configuration is not initialized') if config.nil?

        @config = config
      end

      def set(*keys, value: nil)
        interact(:set, *keys, value: value)
      end

      def append(*values, to: nil)
        interact(:append, *values, to: to)
      end

      def fetch(*keys, default: nil)
        interact(:fetch, *keys, default: default)
      end

      def remove(*values, from: nil)
        interact(:remove, *values, from: from)
      end

      private

      def interact(symbol, *args)
        config.read if config.exist?
        resp = config.public_send(symbol, *args)
        config.write(force: true)
        resp
      end

      attr_reader :config
    end
  end
end
