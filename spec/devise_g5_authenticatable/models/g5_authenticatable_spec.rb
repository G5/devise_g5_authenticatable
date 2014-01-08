require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new(attributes) }
  let(:attributes) { Hash.new }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:uid) }
  it { should_not allow_mass_assignment_of(:g5_access_token) }
  it { should allow_mass_assignment_of(:current_password) }
  it { should allow_mass_assignment_of(:updated_by) }

  describe '#save!' do
    subject(:save) { model.save! }

    context 'when model is new' do
      let(:attributes) do
        {email: email,
         password: password,
         password_confirmation: password_confirmation,
         provider: provider,
         uid: uid,
         current_password: current_password,
         updated_by: updated_by}
      end

      let(:email) { 'test.email@test.host' }
      let(:password) { 'my_secret' }
      let(:password_confirmation) { password }
      let(:current_password) { 'my_current_password' }
      let(:provider) {}
      let(:uid) {}
      let(:updated_by) { model_class.new }

      let(:auth_user_creator) { double(:auth_user_creator, create: auth_user) }
      let(:auth_user) { double(:auth_user, id: auth_id) }
      let(:auth_id) { 1 }

      before do
        allow(Devise::G5::AuthUserCreator).to receive(:new).and_return(auth_user_creator)
      end

      context 'when model is valid' do
        it 'should persist the email' do
          save
          expect(model_class.find(model.id).email).to eq(email)
        end

        it 'should not persist the password' do
          save
          expect(model_class.find(model.id).password).to be_nil
        end

        it 'should not persist the password_confirmation' do
          save
          expect(model_class.find(model.id).password_confirmation).to be_nil
        end

        it 'should not persist the current_password' do
          save
          expect(model_class.find(model.id).current_password).to be_nil
        end

        it 'should not persist updated by' do
          save
          expect(model_class.find(model.id).updated_by).to be_nil
        end

        it 'should initialize a service class for creating auth users' do
          expect(Devise::G5::AuthUserCreator).to receive(:new).with(model).and_return(auth_user_creator)
          save
        end

        it 'should create an auth user' do
          expect(auth_user_creator).to receive(:create)
          save
        end
      end

      context 'when there is an error creating the auth user' do
        before do
          allow(auth_user_creator).to receive(:create).and_raise(error)
        end

        context 'with OAuth2::Error' do
          let(:error) { OAuth2::Error.new(response) }
          let(:response) do
            double(:response, :parsed => error_hash,
                              :body => error_body,
                              :error= => nil)
          end

          let(:error_hash) do
            { 'error' => error_code,
              'error_description' => error_description }
          end

          let(:error_code) { "Email can't be blank" }
          let(:error_description) { 'Validation failed' }
          let(:error_body) { 'problems' }

          it 'should raise a RecordNotSaved error with the OAuth error code' do
            expect { save }. to raise_error(ActiveRecord::RecordNotSaved, error_code)
          end
        end

        context 'with some other error' do
          let(:error) { StandardError.new(error_message) }
          let(:error_message) { 'problems' }

          it 'should raise a RecordNotSaved error' do
            expect { save }.to raise_error(ActiveRecord::RecordNotSaved, error_message)
          end
        end
      end
    end

    context 'when model is updated' do
      let(:model) { create(:user) }

      let(:auth_user_updater) { double(:user_updater, update: auth_user) }
      let(:auth_user) { double(:auth_user, id: auth_id) }
      let(:auth_id) { 'remote-auth-id-42' }
      before do
        allow(Devise::G5::AuthUserUpdater).to receive(:new).and_return(auth_user_updater)
      end

      context 'with successful auth user update' do
        it 'should raise no errors' do
          expect { save }.to_not raise_error
        end

        it 'should initialize the auth user updater' do
          expect(Devise::G5::AuthUserUpdater).to receive(:new).with(model).and_return(auth_user_updater)
          save
        end

        it 'should update the auth user' do
          expect(auth_user_updater).to receive(:update)
          save
        end
      end

      context 'with unsuccessful auth user update' do
        before do
          allow(auth_user_updater).to receive(:update).and_raise(error_message)
        end
        let(:error_message) { 'problems' }

        it 'should raise an error' do
          expect { save }.to raise_error
        end
      end
    end
  end

  describe '#update_with_password' do
    subject { update_with_password }
    let(:update_with_password) { model.update_with_password(params) }

    let(:model) { create(:user) }

    let(:params) do
      {current_password: current_password,
       password: updated_password,
       password_confirmation: updated_password,
       email: updated_email}
    end

    let(:current_password) {}
    let(:updated_password) { 'updated_secret' }
    let(:updated_email) { 'update@email.com' }

    let(:auth_updater) { double(:auth_user_updater, update: true) }
    before { allow(Devise::G5::AuthUserUpdater).to receive(:new).and_return(auth_updater) }

    let(:password_validator) { double(:auth_password_validator) }
    before do
      allow(Devise::G5::AuthPasswordValidator).to receive(:new).
        and_return(password_validator)
    end

    context 'with valid current password' do
      before { allow(password_validator).to receive(:valid_password?).and_return(true) }

      context 'with valid input' do
        it 'should return true' do
          expect(update_with_password).to be_true
        end

        it 'should initialize the auth user updater' do
          expect(Devise::G5::AuthUserUpdater).to receive(:new).with(model).and_return(auth_updater)
          update_with_password
        end

        it 'should update the credentials in the auth server' do
          expect(auth_updater).to receive(:update)
          update_with_password
        end

        it 'should update the email on the local model' do
          expect { update_with_password }.to change { model.email }.to(updated_email)
        end
      end

      context 'when there is a validation error' do
        let(:updated_email) { '' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should not update the credentials on the auth server' do
          expect(auth_updater).to_not receive(:update)
          update_with_password
        end

        it 'should add an error to the email attribute' do
          expect { update_with_password }.to change { model.errors[:email].count }.to(1)
        end
      end
    end

    context 'with invalid current password' do
      before { allow(password_validator).to receive(:valid_password?).and_return(false) }

      context 'when current password is missing' do
        let(:current_password) { '' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should set an error on the current_password attribute' do
          update_with_password
          expect(model.errors[:current_password]).to include("can't be blank")
        end

        it 'should not update user credentials in the remote server' do
          expect(auth_updater).to_not receive(:update)
          update_with_password
        end
      end

      context 'when current password is incorrect' do
        let(:current_password) { 'something wrong' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should set an error on the current_password attribute' do
          update_with_password
          expect(model.errors[:current_password]).to include('is invalid')
        end

        it 'should not update user credentials in the remote server' do
          expect(auth_updater).to_not receive(:update)
          update_with_password
        end
      end
    end
  end

  describe '#clean_up_passwords' do
    subject(:clean_up_passwords) { model.clean_up_passwords }
    let(:model) do
      build_stubbed(:user, password: password,
                           password_confirmation: password)
    end

    let(:password) { 'foobarbaz' }

    it 'should change the password to nil' do
      expect { clean_up_passwords }.to change { model.password }.
        from(password).to(nil)
    end

    it 'should change the password_confirmation to nil' do
      expect { clean_up_passwords }.to change { model.password_confirmation }.
        from(password).to(nil)
    end
  end

  describe '#valid_password?' do
    subject(:valid_password?) { model.valid_password?(password) }

    let(:model) { create(:user) }
    let(:password) { 'foobarbaz' }

    let(:password_validator) { double(:password_validator, valid_password?: valid) }
    before do
      allow(Devise::G5::AuthPasswordValidator).to receive(:new).and_return(password_validator)
    end

    context 'when password is valid' do
      let(:valid) { true }

      it 'should return true' do
        expect(valid_password?).to be_true
      end

      it 'should check the password against the auth server' do
        expect(password_validator).to receive(:valid_password?).
          with(model, password).and_return(true)
        valid_password?
      end
    end

    context 'when password is invalid' do
      let(:valid) { false }

      it 'should return false' do
        expect(valid_password?).to be_false
      end

      it 'should check the password against the auth server' do
        expect(password_validator).to receive(:valid_password?).
          with(model, password).and_return(false)
        valid_password?
      end
    end
  end
end
