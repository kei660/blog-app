class AddUserIdToPosts < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:posts, :user_id) 
      add_reference :posts, :user, null: false, foreign_key: true
    end
  end
end
