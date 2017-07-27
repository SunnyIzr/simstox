require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job, time|
    puts "Running My Nightly Batch Process for #{job}, at #{time}"
    Stock.all.each{ |stock| PullQuotesJob.perform_later(stock)}
    Portfolio.all.each{ |stock| SavePortfolioValueJob.perform_later(portfolio)}
  end

  every(1.day, 'midnight.job', :at => '00:00')
end