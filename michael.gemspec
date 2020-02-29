# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'michael/version'

Gem::Specification.new do |spec|
  spec.name          = 'michael'
  spec.license       = 'MIT'
  spec.version       = Michael::VERSION
  spec.authors       = ['Vitaliy Kudryk']
  spec.email         = ['kudryk.v@gmail.com']

  spec.summary       = 'Operate with github to get PRs'
  spec.description   = 'Operate with github to get PRs'
  spec.homepage      = 'https://github.com/kudrykv/michael'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'parallel', '~> 1.18.0'
  spec.add_dependency 'pastel', '~> 0.7.2'
  spec.add_dependency 'ruby-duration', '~> 3.2.3'
  spec.add_dependency 'thor', '~> 0.20.0'
  spec.add_dependency 'tty-box', '~> 0.4.1'
  spec.add_dependency 'tty-color', '~> 0.5'
  spec.add_dependency 'tty-command', '~> 0.9.0'
  spec.add_dependency 'tty-config', '~> 0.3.2'
  spec.add_dependency 'tty-cursor', '~> 0.7'
  spec.add_dependency 'tty-editor', '~> 0.5'
  spec.add_dependency 'tty-file', '~> 0.8.0'
  spec.add_dependency 'tty-font', '~> 0.4.0'
  spec.add_dependency 'tty-logger', '~> 0.2.0'
  spec.add_dependency 'tty-markdown', '~> 0.6.0'
  spec.add_dependency 'tty-pager', '~> 0.12'
  spec.add_dependency 'tty-pie', '~> 0.3.0'
  spec.add_dependency 'tty-platform', '~> 0.2'
  spec.add_dependency 'tty-progressbar', '~> 0.17'
  spec.add_dependency 'tty-prompt', '~> 0.19'
  spec.add_dependency 'tty-screen', '~> 0.7'
  spec.add_dependency 'tty-spinner', '~> 0.9'
  spec.add_dependency 'tty-table', '~> 0.11.0'
  spec.add_dependency 'tty-tree', '~> 0.3'
  spec.add_dependency 'tty-which', '~> 0.4'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'

  spec.required_ruby_version = '>= 2.5.0'
end
