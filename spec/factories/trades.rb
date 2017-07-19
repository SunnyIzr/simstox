stocks = %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC]

FactoryGirl.define do
  factory :trade do
    quantity { [*10..5_000].sample }
    ticker { stocks.sample }
    price_cents { [*30_00..60_00].sample }
    portfolio_id { Portfolio.all.sample.id }
  end
end