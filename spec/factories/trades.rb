FactoryGirl.define do
  factory :trade do
    quantity { [*10..5_000].sample }
    stock_id { Stock.all.sample.id }
    price_cents { [*30_00..60_00].sample }
    portfolio_id { Portfolio.all.sample.id }
  end
end