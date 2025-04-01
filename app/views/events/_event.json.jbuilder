json.extract! event, :id, :event_name, :description, :date, :location, :venue, :total_seats, :price, :created_at, :updated_at
json.url event_url(event, format: :json)
