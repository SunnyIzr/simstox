FactoryGirl.define do
  factory :portfolio do
    name { Faker::Lorem.words(3).join(' ').capitalize }
    cash_cents { [*100_00..100_000_00].sample }
    user_id { User.last.id }
  end
end