module OpenPull
  class PullRequestDecorator < ::SimpleDelegator
    def as_row(username)
      [title, user(username), labels, status, commits, comments, mergeable,
       html_url.underline, updated_at]
    end

    def title
      title = super
      return title if title.size <= 80

      title[0, 80] + '...'
    end

    def user(other)
      user = super().login
      user == other ? user.blue : user
    end

    def labels
      issue  = rels[:issue].get.data
      labels = issue.rels[:labels].get.data

      labels.map { |l| l.name.yellow }.join(', ')
    end

    def status
      state = rels[:statuses].get.data.map(&:state).first

      case state
      when 'success'
        state.green
      when 'pending'
        state.yellow
      else
        (state || '--').red
      end
    end

    def commits
      num = rels[:commits].get.data.size
      num == 0 ? '' : num
    end

    def comments
      num = rels[:review_comments].get.data.size
      num == 0 ? '' : num
    end

    def mergeable
      super ? 'Yes'.green : 'No'.red
    end

    private

    def rels
      __getobj__.rels
    end
  end
end
