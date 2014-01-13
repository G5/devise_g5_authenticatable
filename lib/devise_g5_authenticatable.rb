require 'devise_g5_authenticatable/version'

require 'devise'
require 'omniauth-g5'

require 'devise_g5_authenticatable/controllers/url_helpers'

Devise.add_module(:g5_authenticatable,
                  strategy: false,
                  route: { session: [:new, :destroy] },
                  model: 'devise_g5_authenticatable/models/g5_authenticatable')
