# frozen_string_literal: true

module OpenPull
  class PullRequestFetcher
    attr_reader :client, :organisation, :username

    def initialize(client, organisation, username = '')
      @client       = client
      @organisation = organisation
      @username     = username
    end

    def fetch
      repos = client.org_repos(organisation).map do |repository|
        Thread.new { fetch_pull_requests(repository) }
      end.map(&:value)

      repos.reject { |v| v.nil? || v.empty? }
    end

    private

    def fetch_pull_requests(repository)
      print '.'.green

      pull_requests = client.pull_requests(repository.id, state: 'open')
      return [] if pull_requests.empty?

      results = pull_requests.map do |pull_request|
        Thread.new { row(pull_request) }
      end.map(&:value)

      [headers(repository, results.size)] + results
    end

    def headers(repository, size)
      head = [
        "#{repository.name} (#{size})",
        repository.private ? 'private' : 'public'
      ]
      head += [''] * 5
      head += [
        repository.html_url,
        ''
      ]
      head.map { |h| h.blue.bold }
    end

    def row(pull_request)
      print '.'.yellow

      OpenPull::PullRequestDecorator.new(
        pull_request.rels[:self].get.data
      ).as_row(username)
    end
  end
end
