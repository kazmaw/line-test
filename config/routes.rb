Rails.application.routes.draw do
  root 'welcome#index'

  mount API::Line => '/'
end
