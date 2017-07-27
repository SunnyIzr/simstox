web: bundle exec rackup config.ru -p $PORT
clock: bundle exec clockwork config/clock.rb
resque: env TERM_CHILD=1 bundle exec rake environment resque:work QUEUE=simstox_worker