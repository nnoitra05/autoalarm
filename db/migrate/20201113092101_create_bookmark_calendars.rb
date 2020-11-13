class CreateBookmarkCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmark_calendars do |t|
      t.references :bookmark, foreign_key: true
      t.references :calendar, foreign_key: true
      t.timestamps
    end
  end
end
