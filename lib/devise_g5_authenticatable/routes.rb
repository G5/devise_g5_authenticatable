module ActionDispatch::Routing
  class Mapper
    protected
    def devise_session(mapping, controllers)
      resource :session, only: [], controller: controllers[:sessions], path: '' do
        get   :new,     path: mapping.path_names[:sign_in], as: :new
        post  :create,  path: mapping.path_names[:sign_in]
        match :destroy, path: mapping.path_names[:sign_out], as: :destroy, via: mapping.sign_out_via
      end

      match 'auth/g5',
        controller: controllers[:sessions],
        action: 'omniauth_passthru',
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
