stocks = %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC]


3.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  username = Faker::Internet.user_name(first_name + ' ' + last_name)
  user = User.create({first_name: first_name, last_name: last_name, username: username})
  5.times do
    portfolio = Portfolio.create({
      name: Faker::Lorem.words(3).join(' ').capitalize,
      cash_cents: [*100_00..100_000_00].sample,
      user_id: user.id
      })
    10.times do
      portfolio.trades.create({
        quantity: [*10..5_000].sample,
        ticker: stocks.sample,
        price_cents: [*30_00..60_00].sample
      })
    end
  end
end