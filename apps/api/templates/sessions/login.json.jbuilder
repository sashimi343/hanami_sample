json.authentication true
json.authenticated_user do
  json.extract! authenticated_user, :id, :name, :email
end
