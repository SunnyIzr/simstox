class AddUsersToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_reference :portfolios, :user, null: false
  end
end
