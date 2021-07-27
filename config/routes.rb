Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/wordofday' => 'jsondata#wordofday'
  get '/jsondata' => 'jsondata#index'
  get '/wordsdetails' => 'jsondata#wordsdetails'
  get '/words/randomWord/api_key:key' => 'jsondata#randomWord'
  get '/words/:word/:action/api_key:key' => 'jsondata#action'
  get '/' => 'users#index'
  get '/+' => 'apigeneration#add'
  get '/X' => 'apigeneration#delete'
  get '/delete' => 'sessions#delete'
  post '/sessions' => 'sessions#create'
  post '/users' => 'users#create'
  get '/jsonpage' =>'jsondata#index'
  get '/words/randomWord' =>'jsondata#index'
  get 'words/word:word/examples' => 'jsondata#index'
  get 'words/word:word/definitions' => 'jsondata#index'
  get 'words/word:word/relatedWords' => 'jsondata#index'
  get '/dashboard' => 'userpage#index'
  get '/logout' => 'sessions#destroy'

end
