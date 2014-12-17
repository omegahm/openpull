module OpenPull
  class Client
    attr_reader :octokit_client, :organisation, :username

    def initialize(access_token, organisation, username)
      @organisation = organisation
      @username     = username

      setup_octokit(access_token)
    end

    def show_table
      OpenPull::Table.show(sub_tables)
    end

    private

    def setup_octokit(access_token)
      stack = Faraday::RackBuilder.new do |b|
        b.use Faraday::HttpCache
        b.use Octokit::Response::RaiseError
        b.adapter Faraday.default_adapter
      end
      Octokit.middleware = stack

      @octokit_client = Octokit::Client.new(access_token: access_token)
      @octokit_client.auto_paginate = true
    end

    def sub_tables
      OpenPull::PullRequestFetcher
        .new(octokit_client, organisation, username)
        .fetch
    end
  end
end
