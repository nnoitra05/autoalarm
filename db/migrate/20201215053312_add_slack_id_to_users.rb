class AddSlackIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slack_id, :string, null: false
  end
end
