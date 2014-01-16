require 'devise_g5_authenticatable/version'

require 'devise'
require 'omniauth-g5'

require 'devise_g5_authenticatable/routes'
require 'devise_g5_authenticatable/controllers/url_helpers'

require 'devise_g5_authenticatable/engine'

Devise.add_module(:g5_authenticatable,
                  strategy: false,
                  route: {session: [nil, :new, :destroy]},
                  controller: :sessions,
                  model: 'devise_g5_authenticatable/model')
