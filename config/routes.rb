NimbleHub::Engine.routes.draw do
  resources :data_sources
  resources :integrations

  get '/auth/callback/:provider', to: 'oauth_callbacks#oauth_callback'
  get 'setup/:provider', to: 'integrations#setup', as: 'integration_setup'
end
