class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.references :friend_a, index: true, foreign_key: { to_table: :users }
      t.references :friend_b, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
