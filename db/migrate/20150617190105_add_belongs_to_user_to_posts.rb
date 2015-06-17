class AddBelongsToUserToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :user_id, :user
  end
end
