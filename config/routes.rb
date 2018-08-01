Rails.application.routes.draw do
  resources :scores
  resources :attempts
  resources :subgenres
  resources :genres
  get 'quiz/index'

  resources :questions
  get 'admin/index'
  # get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/login'), via: [:get, :post]

  get 'admin' => 'admin#index'
  controller :sessions do
  	get 'login' => :new
  	post 'login' => :create
  	get 'logout' => :destroy
  end

  controller :quiz do
    get 'quiz' => 'quiz#index'
  end

  controller :scores do
    get 'scores/fetch/data' => :fetchdata
    get 'scores/oneanswer/:id' => :oneanswer
    get 'scores/numanswer/:id' => :numanswer
    get 'scores/fetch/not' => :notattempted
    get 'scores/genre/:id' => :genleaderboard
    get 'scores/subgenre/:id' => :subgenleaderboard
    get 'scores/update/state' => :updatestate
  end

  controller :questions do
    get 'questions/find/:sid/:gid' => :fromsub 
    get 'questionstp/' => :timepass    
  end

  controller :attempts do
    get 'attempts/find/add' => :showques
    get 'attempts/check/change' => :check
  end

  resources :users
  root 'admin#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
