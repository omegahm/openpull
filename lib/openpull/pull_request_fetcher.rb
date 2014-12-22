module OpenPull
  class PullRequestFetcher
    attr_reader :client, :organisation, :username

    def initialize(client, organisation, username = '')
      @client       = client
      @organisation = organisation
      @username     = username
    end

    def fetch
      client.org_repos(organisation).map do |repository|
        Thread.new { fetch_pull_requests(repository) }
      end.map(&:value).reject { |v| v.nil? || v.empty? }
    end

    private

    def fetch_pull_requests(repository)
      print '.'.green

      pull_requests = client.pull_requests(repository.id, state: 'open')
      return [] if pull_requests.empty?

      header = ["#{repository.name} (#{pull_requests.size})".blue.bold]
      header += [''] * (OpenPull::Table::HEADINGS.size - 1)

      results = pull_requests.map do |pr|
        Thread.new { row(pr) }
      end.map(&:value)

      [header] + results
    end

    def row(pr)
      print '.'.yellow

      deco_pr = OpenPull::PullRequestDecorator.new(pr.rels[:self].get.data)

      [deco_pr.title, deco_pr.user(username), deco_pr.labels,
       deco_pr.status, deco_pr.mergeable, deco_pr.html_url,
       deco_pr.updated_at]
    end
  end
end
