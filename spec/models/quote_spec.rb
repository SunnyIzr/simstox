require 'rails_helper'

RSpec.describe Quote, type: :model do
  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:stock_id) }
  it { should belong_to(:stock)}
end
