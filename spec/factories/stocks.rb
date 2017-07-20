stocks = %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC]

FactoryGirl.define do
  factory :stock do
    ticker { stocks.sample }
  end
end