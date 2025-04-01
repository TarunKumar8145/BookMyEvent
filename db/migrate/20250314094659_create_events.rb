class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :event_name
      t.text :description
      t.datetime :date
      t.string :location
      t.string :venue
      t.integer :total_seats
      t.integer :price

      t.timestamps
    end
  end
end
