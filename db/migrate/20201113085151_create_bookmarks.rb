class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.string :name, null: false
      t.string :departure, null: false
      t.string :destination, null: false
      t.string :time, null: false
      t.boolean :departure_flag, null: false
      t.boolean :status_check, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
