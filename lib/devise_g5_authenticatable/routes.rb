module ActionDispatch::Routing
  class Mapper
    protected
    def devise_g5_authenticatable(mapping, controllers)
      resource :session, only: [], controller: controllers[:g5_sessions], path: '' do
        get   :new,     path: mapping.path_names[:sign_in], as: :new
        post  :create,  path: mapping.path_names[:sign_in]
        match :destroy, path: mapping.path_names[:sign_out], as: :destroy, via: mapping.sign_out_via
      end

      match 'auth/g5',
        controller: controllers[:g5_sessions],
        action: 'passthru',
        as: :g5_authorize,
        via: [:get, :post]

      match 'auth/g5/callback',
        controller: controllers[:g5_sessions],
        action: 'create',
        as: :g5_callback,
        via: [:get, :post]
    end
  end
end
