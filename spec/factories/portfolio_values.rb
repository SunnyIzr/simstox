FactoryGirl.define do
  factory :portfolio_value do
    cash_cents { 75_000_00 }
    market_value_cents { 124_830_38}
    portfolio_id { Portfolio.last.id }
    time { Time.new }
  end
end