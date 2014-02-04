require 'spec_helper'

describe 'Registrations controller' do
  describe 'routing' do
    context 'with user scope' do
      it 'should route GET /users/sign_up' do
        expect(get '/users/sign_up').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                             action: 'new')
      end

      it 'should route POST /users' do
        expect(post '/users').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                          action: 'create')
      end

      it 'should route GET /users/edit' do
        expect(get '/users/edit').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                              action: 'edit')
      end

      it 'should route PUT /users' do
        expect(put '/users').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                         action: 'update')
      end

      it 'should route DELETE /users' do
        expect(delete '/users').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                            action: 'destroy')
      end

      it 'should route GET /users/cancel' do
        expect(get '/users/cancel').to route_to(controller: 'devise_g5_authenticatable/registrations',
                                                action: 'cancel')
      end
    end

    context 'with admin scope' do
      it 'should route GET /registered/admins/custom_sign_up' do
        expect(get '/registered/admins/custom_sign_up').to route_to(controller: 'custom_registrations',
                                                                    action: 'new')
      end

      it 'should route POST /registered/admins' do
        expect(post '/registered/admins').to route_to(controller: 'custom_registrations',
                                                      action: 'create')
      end

      it 'should route GET /registered/admins/edit' do
        expect(get '/registered/admins/edit').to route_to(controller: 'custom_registrations',
                                              action: 'edit')
      end

      it 'should route PUT /registered/admins' do
        expect(put '/registered/admins').to route_to(controller: 'custom_registrations',
                                         action: 'update')
      end

      it 'should route DELETE /registered/admins' do
        expect(delete '/registered/admins').to route_to(controller: 'custom_registrations',
                                                        action: 'destroy')
      end

      it 'should route GET /registered/admins/custom_cancel' do
        expect(get '/registered/admins/custom_cancel').to route_to(controller: 'custom_registrations',
                                                                   action: 'cancel')
      end
    end
  end

  describe 'generated url helpers' do
    context 'with user scope' do
      it 'should generate new_user_registration_path' do
        expect(new_user_registration_path).to eq('/users/sign_up')
      end

      it 'should generate user_registration_path' do
        expect(user_registration_path).to eq('/users')
      end

      it 'should generate edit_user_registration_path' do
        expect(edit_user_registration_path).to eq('/users/edit')
      end

      it 'should generate cancel_user_registration_path' do
        expect(cancel_user_registration_path).to eq('/users/cancel')
      end
    end

    context 'with admin scope' do
      it 'should generate new_admin_registration_path' do
        expect(new_admin_registration_path).to eq('/registered/admins/custom_sign_up')
      end

      it 'should generate admin_registration_path' do
        expect(admin_registration_path).to eq('/registered/admins')
      end

      it 'should generate edit_admin_registration_path' do
        expect(edit_admin_registration_path).to eq('/registered/admins/edit')
      end

      it 'should generate cancel_admin_registration_path' do
        expect(cancel_admin_registration_path).to eq('/registered/admins/custom_cancel')
      end
    end
  end
end
