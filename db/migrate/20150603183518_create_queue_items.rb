class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :position
      t.references :video, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
