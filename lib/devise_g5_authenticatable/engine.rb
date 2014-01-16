module DeviseG5Authenticatable
  class Engine < Rails::Engine
    initializer "devise_g5_authenticatable.helpers" do
      Devise.include_helpers(DeviseG5Authenticatable)
    end
  end
end
