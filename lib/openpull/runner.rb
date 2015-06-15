require 'optparse'

module OpenPull
  class Runner
    class << self
      def run(argv = [])
        new(argv).run
      end
    end

    attr_reader :argv
    attr_accessor :options

    def initialize(argv = [])
      @argv    = argv
      @options = {}
    end

    def run
      op = option_parser
      op.parse!
      check_options(op)

      puts OpenPull::Client.new(@options[:access_token],
                                @options[:organisation],
                                @options[:username]).show_table
    end

    private

    def option_parser
      OptionParser.new do |opts|
        parse_banner(opts)
        parse_options(opts)
        parse_values(opts)
      end
    end

    def parse_banner(opts)
      opts.banner = 'Usage: openpull [options]'

      opts.separator ''
      opts.separator 'Organisation and username can also be set in the ' \
                     'environment as GITHUB_ORGANISATION and GITHUB_USERNAME.'
      opts.separator ''
    end

    def parse_options(opts)
      opts.separator 'Options:'

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

      opts.on_tail('--version', 'Show version') do
        puts OpenPull::VERSION
        exit
      end
    end

    def parse_values(opts)
      parse_organisation(opts)
      parse_username(opts)
    end

    def parse_organisation(opts)
      @options[:organisation] = ENV['GITHUB_ORGANISATION']
      opts.on('-o',
              '--organisation [ORG]',
              String,
              'The Github organisation') do |o|
        @options[:organisation] = o
      end
    end

    def parse_username(opts)
      @options[:username] = ENV['GITHUB_USERNAME']
      opts.on('-u',
              '--username [USER]',
              String,
              'Your Github username') do |u|
        @options[:username] = u
      end
    end

    def check_options(op)
      check_access_token
      check_organisation(op)
    end

    def check_access_token
      @options[:access_token] = ENV['GITHUB_ACCESS_TOKEN']
      return unless @options[:access_token].nil?
      puts 'You need to set the GitHub access token in your environment. ' \
           '(GITHUB_ACCESS_TOKEN)'
      exit
    end

    def check_organisation(op)
      return unless @options[:organisation].nil?
      puts 'You need to either pass GitHub organisation or set it in your ' \
           'environment. (GITHUB_ORGANISATION)'
      puts "\n#{op}"
      exit
    end
  end
end
