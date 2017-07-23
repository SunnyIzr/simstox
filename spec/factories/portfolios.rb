FactoryGirl.define do
  factory :portfolio do
    name { Faker::Lorem.words(3).join(' ').capitalize }
    cash_cents { 1_000_000_00 }
    user_id { User.last.id }
  end
end