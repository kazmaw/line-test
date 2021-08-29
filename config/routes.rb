Rails.application.routes.draw do
  root 'welcome#index'
  mount Line::API => '/'
end
