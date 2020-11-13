class BookmarkCalendar < ApplicationRecord
  belongs_to :calendar
  belongs_to :bookmark
end
