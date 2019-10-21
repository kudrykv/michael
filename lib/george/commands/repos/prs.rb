# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/github/pull_request'
require_relative '../../models/github/guard'

module George
  module Commands
    class Repos
      class Prs < Guard
        def initialize(options)
          @options = options
        end

        def execute(out: $stdout)
          out.puts 'ok'
        end
      end
    end
  end
end
