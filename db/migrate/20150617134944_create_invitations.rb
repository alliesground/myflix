class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_email
      t.string :recipient_name
      t.text :message
      t.integer :inviter_id, index: true
      t.integer :recipient_id, index: true

      t.timestamps
    end

    add_index :invitations, :inviter_id
    add_index :invitations, :recipient_id
  end
end
