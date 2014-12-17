$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'openpull/version'

Gem::Specification.new do |s|
  s.name = 'openpull'
  s.version = OpenPull::VERSION
  s.date = '2014-12-17'
  s.summary = 'Fetches Open Pull-Requests from Github'
  s.description = 'Fetches open pull-requests, with status and mergability, ' \
                  'in your organisation.'
  s.authors = ['Mads Ohm Larsen']
  s.email = 'mads.ohm@gmail.com'
  s.homepage = 'http://ohm.sh/'
  s.files = Dir['{lib}/**/*']
  s.license = 'MIT'

  s.executables << 'openpull'

  s.add_dependency 'octokit', '~> 3.7'
  s.add_dependency 'colorize', '~> 0.7'
  s.add_dependency 'terminal-table', '~> 1.4'
  s.add_dependency 'faraday-http-cache', '~> 0.4'
end
