# frozen_string_literal: true

require_relative '../../command'
require_relative '../../models/guard'

module Michael
  module Commands
    class Repos
      class Edit < Guard
        def initialize(options)
          super()

          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          list = repos_config.fetch(:repos)
          repos_config.append('org/repo', to: :repos) if list.nil? || list.empty?

          editor.open(repos_config.config_file_path)
        end
      end
    end
  end
end
