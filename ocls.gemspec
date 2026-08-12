# frozen_string_literal: true

require_relative 'lib/ocls/version'

Gem::Specification.new do |spec|
  spec.name = 'ocls'
  spec.version = Ocls::VERSION
  spec.authors = ['luang']
  spec.summary = 'List recent opencode sessions from the terminal'
  spec.description = 'Queries the opencode SQLite database and prints styled session listings.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.files = Dir['lib/**/*.rb', 'bin/*', 'LICENSE.txt', 'README.md']
  spec.bindir = 'bin'
  spec.executables = ['ocls']

  spec.add_dependency 'pastel', '~> 0.8'
  spec.add_dependency 'sqlite3', '~> 2.0'
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'tty-screen', '~> 0.8'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
