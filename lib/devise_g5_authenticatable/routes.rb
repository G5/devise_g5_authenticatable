module ActionDispatch::Routing
  class Mapper
    protected
    def devise_g5_authenticatable(mapping, controllers)
      devise_session(mapping, controllers)

      match 'auth/g5',
        controller: controllers[:sessions],
        action: 'passthru',
        as: :g5_authorize,
        via: [:get, :post]

      match 'auth/g5/callback',
        controller: controllers[:sessions],
        action: 'create',
        as: :g5_callback,
        via: [:get, :post]
    end
  end
end
