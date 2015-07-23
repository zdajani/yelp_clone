class RemoveRestaurantIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :User_Id, :string
  end
end
