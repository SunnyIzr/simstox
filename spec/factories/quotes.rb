FactoryGirl.define do
  factory :quote do
    price_cents { [*30_00..60_00].sample }
    time { Time.now }
    stock_id { Stock.all.sample.id }
  end
end