class AddTransactionIdToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :transaction_id, :string
  end
end
