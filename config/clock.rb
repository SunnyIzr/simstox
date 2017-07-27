require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    p "Running #{job}"
    p "*"*100
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  # every(1.seconds, 'frequent.job')
  # every(3.minutes, 'less.frequent.job')
  # every(1.hour, 'hourly.job')

  every(1.day, 'midnight.job', :at => '00:00')
end