require 'spec_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:password_digest) }
  it { should have_many(:portfolios) }

  it 'should validate uniqueness of username' do
    user1 = FactoryGirl.create(:user, username: 'user1')
    user2 = FactoryGirl.build(:user, username: 'user1')  

    expect(user2).to_not be_valid
  end

  it 'should downcase username upon save' do
    user = FactoryGirl.create(:user, username: 'CAPS-USERNAME')

    expect(user.username).to eq('caps-username')
  end
end
