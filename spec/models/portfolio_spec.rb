require 'spec_helper'

describe Portfolio do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cash_cents) }
  it { should have_many(:trades) }
end
