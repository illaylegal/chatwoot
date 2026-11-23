class AddKnownContactsOnlyToChannelEmail < ActiveRecord::Migration[8.0]
  def change
    add_column :channel_email, :known_contacts_only, :boolean, default: false, null: false
  end
end
