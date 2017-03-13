json.array!(@teams) do |team|
  json.extract! team, :id, :name, :manager
  json.url team_url(team, format: :json)
end
