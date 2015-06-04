json.array!(@trips) do |trip|
  json.extract! trip, :id, :dest_state, :return_date, :description
  json.url trip_url(trip, format: :json)
end
