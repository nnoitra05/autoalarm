class Bookmark < ApplicationRecord
  belongs_to :user
  has_many :bookmark_calendars, dependent: :destroy
  has_many :calendars, through: :bookmark_calendars

  validates :name, presence: true
  validates :departure, presence: true
  validates :destination, presence: true
  validates :time, presence: true
  validates :status_check, presence: true 
end
