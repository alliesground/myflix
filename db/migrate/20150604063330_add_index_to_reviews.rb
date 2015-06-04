class AddIndexToReviews < ActiveRecord::Migration
  def change
    add_index :reviews, [:user_id, :video_id], unique: true
  end
end
