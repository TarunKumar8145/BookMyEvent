class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  scope :confirmed, -> { where(status: "confirmed") }
  validates :tickets, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }

  # enum status: { pending: 0, confirmed: 1 }  # Add status field
end
