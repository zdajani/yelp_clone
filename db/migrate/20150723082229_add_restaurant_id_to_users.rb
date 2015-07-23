class AddRestaurantIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :restaurant, :has_many
  end
end
