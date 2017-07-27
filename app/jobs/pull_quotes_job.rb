class PullQuotesJob < ApplicationJob
  queue_as :simstox_worker

  def perform(stock)
    stock.save_latest_quote
  end
end
