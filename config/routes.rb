RedditRadioApp::Application.routes.draw do
  # match '/' => 'mobile#home', constraints: {subdomain: "m" }, as: :mobile
  # get 'mobile_form' => 'mobile#shuffler', constraints: {subdomain: "m"}, as: :mobile_form
  get 'nextmob' => 'mobile#next', as: :mobile_next
  
  get '/m/' => 'mobile#home', as: :mobile2
  get '/m/mobile_form' => 'mobile#shuffler', as: :mobile_form2  
  
  root :to => 'pages#home'
  get '/play' => 'pages#shuffler'
  post '/play' => 'pages#shuffler', as: :shuffle
  post '/login' => 'sessions#new', as: :signin
  get '/add' => 'pages#add_sub', as: :add
  get '/remove' => 'pages#remove_sub', as: :remove
  get 'next' => 'pages#next', as: :next
  get '/done' => 'pages#done', as: :done
  
  get 'test' => 'pages#test', as: :test
  
  get 'sesame' => 'pages#sesame', as: :sesame
  
  

end
