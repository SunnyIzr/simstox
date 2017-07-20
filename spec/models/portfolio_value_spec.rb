require 'spec_helper'

RSpec.describe PortfolioValue, type: :model do
  it { should validate_presence_of(:cash_cents) }
  it { should validate_presence_of(:market_value_cents) }
  it { should validate_presence_of(:portfolio_id) }
  it { should validate_presence_of(:time) }
  it { should belong_to(:portfolio) }
end
