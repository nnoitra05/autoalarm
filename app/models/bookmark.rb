class Bookmark < ApplicationRecord
  belongs_to :user
  has_many :bookmark_calendars
  has_many :calendars, through: :bookmark_calendars, dependent: :destroy

  validates :date, presence: true
  validates :departure, presence: true
  validates :destination, presence: true
  validates :time, presence: true
  validates :status_check, presence: true 
end
