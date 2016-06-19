Rails.application.routes.draw do

  get ':controller(/:action(/:id(.:format)))'
  post ':controller(/:action(/:id(.:format)))'

  resource :currencies
  resource :rate_comparisons

  root to: "currency#index"

end
