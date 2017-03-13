json.array!(@events) do |event|
  json.extract! event, :id, :name, :startime, :endtime, :amount, :venue
  json.url event_url(event, format: :json)
end
