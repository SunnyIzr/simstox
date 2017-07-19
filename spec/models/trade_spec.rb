require 'spec_helper'

describe Trade do
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:ticker) }
  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:portfolio_id) }
  it { should belong_to(:portfolio) }
end
