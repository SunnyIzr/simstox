stocks = %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC]

5.times do
  portfolio = Portfolio.create({
    name: Faker::Lorem.words(3).join(' ').capitalize,
    cash_cents: [*100_00..100_000_00].sample
    })
  10.times do
    portfolio.trades.create({
      quantity: [*10..5_000].sample,
      ticker: stocks.sample,
      price_cents: [*30_00..60_00].sample
    })
  end
end