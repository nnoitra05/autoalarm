class Calendar < ApplicationRecord

  belongs_to :user
  has_many :bookmark_calendars, dependent: :destroy
  has_many :bookmarks, through: :bookmark_calendars

  validates :date, presence: true
end
