json.array!(@githubs) do |github|
  json.extract! github, :id, :name
  json.url github_url(github, format: :json)
end
