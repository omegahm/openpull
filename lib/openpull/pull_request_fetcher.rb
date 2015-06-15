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

      results = pull_requests.map do |pr|
        Thread.new { row(pr) }
      end.map(&:value)

      [headers(repository, results.size)] + results
    end

    def headers(repository, size)
      visibility = repository.private ? 'private' : 'public'

      [
        "#{repository.name} (#{size})",
        visibility
      ] +
        [''] * 5 +
        [
          repository.html_url,
          ''
        ].map { |h| h.blue.bold }
    end

    def row(pr)
      print '.'.yellow

      pr_data = pr.rels[:self].get.data
      OpenPull::PullRequestDecorator.new(pr_data).as_row(username)
    end
  end
end
