class SavePortfolioValueJob < ApplicationJob
  queue_as :default

  def perform(portfolio)
    portfolio.save_value
  end
end
