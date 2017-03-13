json.array!(@users) do |user|
  json.extract! user, :id, :name, :empid, :dateofbirth, :gender
  json.url user_url(user, format: :json)
end
