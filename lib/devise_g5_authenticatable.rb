# frozen_string_literal: true

require 'devise_g5_authenticatable/version'

require 'devise'

require 'devise_g5_authenticatable/omniauth'
require 'devise_g5_authenticatable/routes'
require 'devise_g5_authenticatable/controllers/helpers'
require 'devise_g5_authenticatable/controllers/url_helpers'

require 'devise_g5_authenticatable/engine'

# Custom devise configuration options
module Devise
  # Should devise_g5_authenticatable validate the user's access token
  # against the auth server for every request? Default is false
  @@g5_strict_token_validation = false

  mattr_accessor :g5_strict_token_validation
end

Devise.add_module(:g5_authenticatable,
                  strategy: false,
                  route: { session: [nil, :new, :destroy] },
                  controller: :sessions,
                  model: 'devise_g5_authenticatable/models/g5_authenticatable')
