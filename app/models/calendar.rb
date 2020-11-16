class Calendar < ApplicationRecord
  belongs_to :user
  has_many :bookmark_calendars
  has_many :bookmarks, through: :bookmark_calendars, dependent: :destroy

  validates :date, presence: true
end
