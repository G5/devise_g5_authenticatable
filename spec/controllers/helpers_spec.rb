require 'spec_helper'

describe DeviseG5Authenticatable::Helpers do
  controller(ActionController::Base) do
    include Devise::Controllers::Helpers
    include DeviseG5Authenticatable::Helpers

    before_filter :clear_blank_passwords, only: :index

    def index
      render status: 200, text: 'Clear passwords'
    end
  end

  before { request.env['devise.mapping'] = Devise.mappings[scope] }
  let(:scope) { :user }

  describe '#clear_blank_passwords' do
    subject(:clear_passwords) { get :index, password_params }
    before { clear_passwords }

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

      let(:password) { 'some_secret' }
      let(:password_confirmation) { 'some_other_secret' }
      let(:current_password) { 'current_secret' }

      context 'with user scope' do
        let(:scope) { :user }

        context 'with non-blank password params' do
          it 'should not change the password param' do
            expect(controller.params[:user][:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(controller.params[:user][:password_confirmation]).to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(controller.params[:user][:current_password]).to eq(current_password)
          end

          it 'should not change the non-password param' do
            expect(controller.params[:user][:email]).to eq(password_params[:user][:email])
          end
        end

        context 'when password is nil' do
          let(:password) {}

          it 'should set the password param to nil' do
            expect(controller.params[:user][:password]).to be_nil
          end

          it 'should not change the password confirmation param' do
            expect(controller.params[:user][:password_confirmation]).to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(controller.params[:user][:current_password]).to eq(current_password)
          end
        end

        context 'when password is blank' do
          let(:password) { '                ' }

          it 'should set the password param to nil' do
            expect(controller.params[:user][:password]).to be_nil
          end

          it 'should not change the password confirmation param' do
            expect(controller.params[:user][:password_confirmation]).to eq(password_confirmation)
          end

          it 'should not change the current_password param' do
            expect(controller.params[:user][:current_password]).to eq(current_password)
          end
        end

        context 'when password confirmation is nil' do
          let(:password_confirmation) {}

          it 'should not change the password param' do
            expect(controller.params[:user][:password]).to eq(password)
          end

          it 'should set the password_confirmation param to nil' do
            expect(controller.params[:user][:password_confirmation]).to be_nil
          end

          it 'should not change the current_password param' do
            expect(controller.params[:user][:current_password]).to eq(current_password)
          end
        end

        context 'when password confirmation is blank' do
          let(:password_confirmation) { '      ' }

          it 'should not change the password param' do
            expect(controller.params[:user][:password]).to eq(password)
          end

          it 'should set the password_confirmation param to nil' do
            expect(controller.params[:user][:password_confirmation]).to be_nil
          end

          it 'should not change the current_password param' do
            expect(controller.params[:user][:current_password]).to eq(current_password)
          end
        end

        context 'when current_password is nil' do
          let(:current_password) {}

          it 'should not change the password param' do
            expect(controller.params[:user][:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(controller.params[:user][:password_confirmation]).to eq(password_confirmation)
          end

          it 'should set the current password param to nil' do
            expect(controller.params[:user][:current_password]).to be_nil
          end
        end

        context 'when current_password is blank' do
          let(:current_password) { '   ' }

          it 'should not change the password param' do
            expect(controller.params[:user][:password]).to eq(password)
          end

          it 'should not change the password_confirmation param' do
            expect(controller.params[:user][:password_confirmation]).to eq(password_confirmation)
          end

          it 'should set the current password param to nil' do
            expect(controller.params[:user][:current_password]).to be_nil
          end
        end
      end

      context 'with admin scope' do
        let(:scope) { :admin }

        context 'when password is blank' do
          let(:password) { '              ' }

          it 'should set the admin password param to nil' do
            expect(controller.params[:admin][:password]).to be_nil
          end
        end

        context 'when password confirmation is blank' do
          let(:password_confirmation) { '     ' }

          it 'should set the admin password confirmation to nil' do
            expect(controller.params[:admin][:password_confirmation]).to be_nil
          end
        end

        context 'when current password is blank' do
          let(:current_password) { '   ' }

          it 'should set the admin current password param to nil' do
            expect(controller.params[:admin][:current_password]).to be_nil
          end
        end
      end
    end

    context 'when there are no password params' do
      let(:password_params) { Hash.new }

      it 'should not change any params' do
        expect(controller.params[scope]).to be_nil
      end
    end
  end
end
