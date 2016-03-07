json.array!(@users) do |user|
  json.extract! user, :name, :role, :email
end
