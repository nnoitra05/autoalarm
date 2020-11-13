class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.string :name, null: false
      t.string :departure, null: false
      t.string :destination, null: false
      t.datetime :time, null: false
      t.boolean :status_check, null: false
      t.timestamps
    end
  end
end