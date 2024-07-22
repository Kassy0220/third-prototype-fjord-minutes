class AddSentInvitationToMinutes < ActiveRecord::Migration[7.1]
  def change
    add_column :minutes, :sent_invitation, :boolean, default: false
  end
end
