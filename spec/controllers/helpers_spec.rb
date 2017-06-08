# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviseG5Authenticatable::Helpers do
  controller(ActionController::Base) do
    include Devise::Controllers::Helpers
    include DeviseG5Authenticatable::Helpers
  end

  describe '#clear_blank_passwords' do
    subject(:clear_passwords) { get(:index, build_params(password_params)) }
    before { clear_passwords }

    controller do
      before_action :clear_blank_passwords, only: :index

      def index
        render status: 200, plain: 'Index'
      end
    end

    context 'when password params are populated' do
      let(:password_params) do
        {
          scope => {
            password: password,
            password_confirmation: password_confirmation,
            current_password: current_password,
            email: 'foo@test.host'
          }
        }
      end

      let(:scope) { :user }

      let(:password) { 'some_secret' }
      let(:password_confirmation) { 'some_other_secret' }
      let(:current_password) { 'current_secret' }

      let(:scope_params) { controller.params[scope] }

      context 'with user scope' do
        let(:scope) { :user }

        context 'with non-blank password params' do
          it 'should not change the password param' do
            expect(scope_params[:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(scope_params[:password_confirmation])
              .to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(scope_params[:current_password]).to eq(current_password)
          end

          it 'should not change the non-password param' do
            expect(scope_params[:email]).to eq(password_params[:user][:email])
          end
        end

        context 'when password is nil' do
          let(:password) {}

          it 'should set the password param to nil' do
            expect(scope_params[:password]).to be_nil
          end

          it 'should not change the password confirmation param' do
            expect(scope_params[:password_confirmation])
              .to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(scope_params[:current_password]).to eq(current_password)
          end
        end

        context 'when password is blank' do
          let(:password) { '                ' }

          it 'should set the password param to nil' do
            expect(scope_params[:password]).to be_nil
          end

          it 'should not change the password confirmation param' do
            expect(scope_params[:password_confirmation])
              .to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(scope_params[:current_password]).to eq(current_password)
          end
        end

        context 'when password confirmation is nil' do
          let(:password_confirmation) {}

          it 'should not change the password param' do
            expect(scope_params[:password]).to eq(password)
          end

          it 'should set the password_confirmation param to nil' do
            expect(scope_params[:password_confirmation]).to be_nil
          end

          it 'should not change the current_password param' do
            expect(scope_params[:current_password]).to eq(current_password)
          end
        end

        context 'when password confirmation is blank' do
          let(:password_confirmation) { '      ' }

          it 'should not change the password param' do
            expect(scope_params[:password]).to eq(password)
          end

          it 'should set the password_confirmation param to nil' do
            expect(scope_params[:password_confirmation]).to be_nil
          end

          it 'should not change the current_password param' do
            expect(scope_params[:current_password]).to eq(current_password)
          end
        end

        context 'when current_password is nil' do
          let(:current_password) {}

          it 'should not change the password param' do
            expect(scope_params[:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(scope_params[:password_confirmation])
              .to eq(password_confirmation)
          end

          it 'should set the current password param to nil' do
            expect(scope_params[:current_password]).to be_nil
          end
        end

        context 'when current_password is blank' do
          let(:current_password) { '   ' }

          it 'should not change the password param' do
            expect(scope_params[:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(scope_params[:password_confirmation])
              .to eq(password_confirmation)
          end

          it 'should set the current password param to nil' do
            expect(scope_params[:current_password]).to be_nil
          end
        end
      end

      context 'with admin scope' do
        let(:scope) { :admin }

        context 'when password is blank' do
          let(:password) { '              ' }

          it 'should set the admin password param to nil' do
            expect(scope_params[:password]).to be_nil
          end
        end

        context 'when password confirmation is blank' do
          let(:password_confirmation) { '     ' }

          it 'should set the admin password confirmation to nil' do
            expect(scope_params[:password_confirmation]).to be_nil
          end
        end

        context 'when current password is blank' do
          let(:current_password) { '   ' }

          it 'should set the admin current password param to nil' do
            expect(scope_params[:current_password]).to be_nil
          end
        end
      end
    end

    context 'when there are no password params' do
      let(:password_params) { {} }

      it 'should not change any params' do
        expect(controller.params[:user]).to be_nil
      end
    end
  end

  describe '#set_updated_by_user' do
    subject(:set_updated_by_user) { post(:create, build_params(user_params)) }

    controller do
      define_helpers(:user)
      define_helpers(:admin)

      before_action :set_updated_by_user, only: :create

      def create
        render status: 200, plain: 'Create'
      end
    end

    before { sign_in(current_user, scope: :user) }
    let(:current_user) { create(:user) }

    before { set_updated_by_user }

    context 'when there is a user param' do
      let(:user_params) { { user: attributes_for(:user) } }

      it 'should set the user updated_by' do
        expect(controller.params[:user][:updated_by]).to eq(current_user)
      end
    end

    context 'when there is no user param' do
      let(:user_params) { {} }

      it 'should set the updated_by' do
        expect(controller.params[:updated_by]).to eq(current_user)
      end
    end
  end

  describe '#set_updated_by_admin' do
    subject(:set_updated_by_admin) { post(:create, build_params(admin_params)) }

    controller do
      define_helpers(:user)
      define_helpers(:admin)

      before_action :set_updated_by_admin, only: :create

      def create
        render status: 200, plain: 'Create'
      end
    end

    before { sign_in(current_admin, scope: :admin) }
    let(:current_admin) { create(:admin) }

    before { set_updated_by_admin }

    context 'when there is an admin param' do
      let(:admin_params) { { admin: attributes_for(:admin) } }

      it 'should set the admin updated_by' do
        expect(controller.params[:admin][:updated_by]).to eq(current_admin)
      end
    end

    context 'when there is no admin param' do
      let(:admin_params) { {} }

      it 'should set the updated_by' do
        expect(controller.params[:updated_by]).to eq(current_admin)
      end
    end
  end

  describe '#handle_resource_error' do
    subject(:action_with_error) { post(:create) }

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    controller(DeviseController) do
      rescue_from ActiveRecord::RecordNotSaved, with: :handle_resource_error

      def create
        self.resource = resource_class.new
        raise ActiveRecord::RecordNotSaved, 'my_error'
      end

      # Expose protected resource helper for the purposes of this unit test
      def resource
        super
      end
    end

    before { action_with_error }

    it 'should be successful' do
      expect(response).to be_success
    end

    it 'should set the base error on the resource' do
      expect(controller.resource.errors[:base]).to eq(['my_error'])
    end
  end
end
