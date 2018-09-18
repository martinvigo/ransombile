Rails.application.routes.draw do
  get 'ransombile/index'
  get 'ransombile/checkMail'

  get 'google/initiate'
  get 'google/finish'

  get 'twitter/initiate'
  get 'twitter/finish'

  get 'facebook/initiate'
  get 'facebook/finish'

  get 'linkedin/initiate'
  get 'linkedin/finish'

  get 'paypal/initiate'
  get 'paypal/finish'

  get 'ebay/initiate'
  get 'ebay/finish'

  get 'wordpress/initiate'
  get 'wordpress/finish'

  get 'steam/initiate'
  get 'steam/finish'
  
  root 'ransombile#index'
end
