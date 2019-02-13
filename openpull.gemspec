# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __dir__)
require 'openpull/version'

Gem::Specification.new do |s|
  s.name = 'openpull'
  s.version = OpenPull::VERSION
  s.summary = 'Fetches Open Pull-Requests from Github'
  s.description = 'Fetches open pull-requests, with status and mergability, ' \
                  'in your organisation.'
  s.authors = ['Mads Ohm Larsen']
  s.email = 'mads.ohm@gmail.com'
  s.homepage = 'https://ohm.sh/'
  s.files = Dir['{lib}/**/*']
  s.license = 'MIT'

  s.executables << 'openpull'

  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'faraday-http-cache', '~> 0.4.2'
  s.add_dependency 'octokit', '~> 3.8.0'
  s.add_dependency 'terminal-table', '~> 1.8.0'

  s.add_development_dependency 'rubocop', '~> 0.64'
end
