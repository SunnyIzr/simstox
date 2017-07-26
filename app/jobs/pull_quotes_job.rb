class PullQuotesJob < ApplicationJob
  queue_as :default

  def perform()
    u = User.last.username + '1'
    User.create(first_name: 'Test', last_name: 'Job', username: u, password: 'password')
  end
end
