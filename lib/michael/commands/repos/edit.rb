# frozen_string_literal: true

module Michael
  module Commands
    class Repos
      class Edit
        def initialize(repos_filepath, cfg, editor, options)
          super()

          @repos_filepath = repos_filepath
          @cfg = cfg
          @editor = editor
          @options = options
        end

        def execute
          list = cfg.fetch(:repos)
          cfg.append('org/repo', to: :repos) if list.nil? || list.empty?

          editor.open(repos_filepath)
        end

        private

        attr_reader :repos_filepath, :cfg, :editor
      end
    end
  end
end
