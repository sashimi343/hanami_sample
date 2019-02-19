# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
post '/users', to: 'users#create'
post '/login', to: 'sessions#login'
get '/profile', to: 'profile#index'
