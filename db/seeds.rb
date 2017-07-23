stocks = %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC]

stocks.each do |stock|
  Stock.create(ticker: stock)
end

3.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  username = Faker::Internet.user_name(first_name + ' ' + last_name)
  user = User.create({first_name: first_name, last_name: last_name, username: username, password: 'password'})
  5.times do
    portfolio = Portfolio.create({
      name: Faker::Lorem.words(3).join(' ').capitalize,
      cash_cents: [*100_00..100_000_00].sample,
      user_id: user.id
      })
    10.times do
      portfolio.trades.create({
        quantity: [*10..5_000].sample,
        stock: Stock.all.sample,
        price_cents: [*30_00..60_00].sample
      })
    end
  end

end

Stock.all.each do |stock|
  stock.save_historical_quotes
end

returns = [0.97, 1.03, 1.05, 1.1, 0.9, 0.75, 0.87, 0.99, 0.94]
Portfolio.all.each do |portfolio|
  market_value = ( portfolio.market_value * 100 ).to_i
  time = Time.new
  100.times do
    PortfolioValue.create(cash_cents: portfolio.cash_cents, market_value_cents: market_value, portfolio_id: portfolio.id, time: time)
    market_value = (market_value * returns.sample).to_i
    time = time - 1.day
  end
end