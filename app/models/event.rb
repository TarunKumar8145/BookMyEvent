class Event < ApplicationRecord
  has_one_attached :image
  has_many :bookings, dependent: :destroy

  validates :image, content_type: [ "image/png", "image/jpeg" ]
  validates :total_seats, numericality: { greater_than_or_equal_to: 0 }

  def available_seats
    total_seats - bookings.where(status: "confirmed").sum(:tickets)  # ✅ Only count confirmed bookings
  end
end
