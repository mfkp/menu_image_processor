MenuImageProcessor::Application.routes.draw do
  root :to => 'menus#index'

  resources :menus
  match 'menus/:id/row/:number' => 'menus#edit_row'
  match 'menus/:id/row/:number/update' => 'menus#update_row'
  match 'menus/:id/download' => 'menus#download'

  match 'pictures/search/:keywords' => 'pictures#search', :as => :search
  match 'pictures/search' => 'pictures#search'
  resources :pictures

end
