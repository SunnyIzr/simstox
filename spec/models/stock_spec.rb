require 'spec_helper'

RSpec.describe Stock, type: :model do
  it { should validate_presence_of(:ticker) }
  it { should have_many(:trades) }
  it { should have_many(:quotes) }
end
