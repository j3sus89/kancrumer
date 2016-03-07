json.array!(@projects) do |project|
  json.extract! project, :name, :scrumMaster, :productOwner
  json.url project_url(project, format: :json)
end
