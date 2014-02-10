require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new(attributes) }
  let(:attributes) { Hash.new }


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
        before { save }

        it 'should persist the email' do
          expect(model_class.find(model.id).email).to eq(email)
        end

        it 'should not persist the password' do
          expect(model_class.find(model.id).password).to be_nil
        end

        it 'should not persist the password_confirmation' do
          expect(model_class.find(model.id).password_confirmation).to be_nil
        end

        it 'should not persist the current_password' do
          expect(model_class.find(model.id).current_password).to be_nil
        end

        it 'should not persist updated by' do
          expect(model_class.find(model.id).updated_by).to be_nil
        end

        it 'should initialize a service class for creating auth users' do
          expect(Devise::G5::AuthUserCreator).to have_received(:new).with(model)
        end

        it 'should create an auth user' do
          expect(auth_user_creator).to have_received(:create)
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
        before { save }

        it 'should initialize the auth user updater' do
          expect(Devise::G5::AuthUserUpdater).to have_received(:new).with(model)
        end

        it 'should update the auth user' do
          expect(auth_user_updater).to have_received(:update)
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

      before { update_with_password }

      context 'with valid input' do
        it 'should return true' do
          expect(update_with_password).to be_true
        end

        it 'should initialize the auth user updater' do
          expect(Devise::G5::AuthUserUpdater).to have_received(:new).with(model)
        end

        it 'should update the credentials in the auth server' do
          expect(auth_updater).to have_received(:update)
        end

        it 'should update the email on the local model' do
          expect(model.email).to eq(updated_email)
        end
      end

      context 'when there is a validation error' do
        let(:updated_email) { '' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should not update the credentials on the auth server' do
          expect(auth_updater).to_not have_received(:update)
        end

        it 'should add an error to the email attribute' do
          expect(model.errors[:email].count).to eq(1)
        end
      end
    end

    context 'with invalid current password' do
      before { allow(password_validator).to receive(:valid_password?).and_return(false) }

      before { update_with_password }

      context 'when current password is missing' do
        let(:current_password) { '' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should set an error on the current_password attribute' do
          expect(model.errors[:current_password]).to include("can't be blank")
        end

        it 'should not update user credentials in the remote server' do
          expect(auth_updater).to_not have_received(:update)
        end
      end

      context 'when current password is incorrect' do
        let(:current_password) { 'something wrong' }

        it 'should return false' do
          expect(update_with_password).to be_false
        end

        it 'should set an error on the current_password attribute' do
          expect(model.errors[:current_password]).to include('is invalid')
        end

        it 'should not update user credentials in the remote server' do
          expect(auth_updater).to_not have_received(:update)
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

    before { valid_password? }

    context 'when password is valid' do
      let(:valid) { true }

      it 'should return true' do
        expect(valid_password?).to be_true
      end

      it 'should initialize the validator with the model' do
        expect(Devise::G5::AuthPasswordValidator).to have_received(:new).with(model)
      end

      it 'should check the password against the auth server' do
        expect(password_validator).to have_received(:valid_password?).with(password)
      end
    end

    context 'when password is invalid' do
      let(:valid) { false }

      it 'should return false' do
        expect(valid_password?).to be_false
      end

      it 'should initialize the validator with the model' do
        expect(Devise::G5::AuthPasswordValidator).to have_received(:new).with(model)
      end

      it 'should check the password against the auth server' do
        expect(password_validator).to have_received(:valid_password?).with(password)
      end
    end
  end

  describe '.find_and_update_for_g5_oauth' do
    subject(:find_and_update) { model_class.find_and_update_for_g5_oauth(auth_data) }

    let(:auth_data) do
      OmniAuth::AuthHash.new({
        provider: 'g5',
        uid: '123999',
        info: {name: 'Foo Bar',
               email: 'foo@bar.com'},
        credentials: {token: 'abc123'}
      })
    end

    context 'when model exists' do
      let!(:model) do
        create(:user, provider: auth_data['provider'],
                      uid: auth_data['uid'],
                      g5_access_token: 'old_token')
      end

      it 'should return the model' do
        expect(find_and_update).to eq(model)
      end

      it 'should save the updated g5_access_token' do
        find_and_update
        model.reload
        expect(model.g5_access_token).to eq(auth_data.credentials.token)
      end
    end

    context 'when model does not exist' do
      it 'should return nothing' do
        expect(find_and_update).to be_nil
      end
    end
  end

  describe '.find_for_g5_oauth' do
    subject(:find_for_g5_oauth) { model_class.find_for_g5_oauth(auth_data) }

    let(:auth_data) do
      OmniAuth::AuthHash.new({
        provider: 'g5',
        uid: uid,
        info: {name: 'Foo Bar',
               email: 'foo@bar.com'},
        credentials: {token: 'abc123'}
      })
    end

    context 'when model exists' do
      let!(:model) do
        create(:user, provider: auth_data.provider,
                      uid: uid.to_s)
      end

      context 'when auth data uid is an integer' do
        let(:uid) { 42 }

        it 'should return the model' do
          expect(find_for_g5_oauth).to eq(model)
        end

        it 'should not create any new models' do
          expect { find_for_g5_oauth }.to_not change { model_class.count }
        end
      end

      context 'when auth data uid is a string' do
        let(:uid) { 'some/crazy/string1234#id' }

        it 'should return the model' do
          expect(find_for_g5_oauth).to eq(model)
        end

        it 'should not create any new models' do
          expect { find_for_g5_oauth }.to_not change { model_class.count }
        end
      end
    end

    context 'when model does not exist' do
      let(:uid) { '42' }

      it 'should not return anything' do
        expect(find_for_g5_oauth).to be_nil
      end

      it 'should not create any new models' do
        expect { find_for_g5_oauth }.to_not change { model_class.count }
      end
    end
  end

  describe '#update_g5_credentials' do
    subject(:update_g5_credentials) { model.update_g5_credentials(auth_data) }

    let(:auth_data) do
      OmniAuth::AuthHash.new({
        provider: 'g5',
        uid: '123999',
        info: {name: 'Foo Bar',
               email: 'foo@bar.com'},
        credentials: {token: 'abc123'}
      })
    end

    let(:model) do
      create(:user, provider: auth_data['provider'],
                    uid: auth_data['uid'],
                    g5_access_token: 'old_token')
    end

    it 'should update the g5_access_token' do
      expect { update_g5_credentials }.to change { model.g5_access_token }.to(auth_data.credentials.token)
    end

    it 'should not save the changes' do
      update_g5_credentials
      expect(model.g5_access_token_changed?).to be_true
    end
  end

  describe '#revoke_g5_credentials!' do
    subject(:revoke_g5_credentials!) { model.revoke_g5_credentials! }

    let(:auth_updater) { double(:auth_user_updater, update: nil) }
    before { allow(Devise::G5::AuthUserUpdater).to receive(:new).and_return(auth_updater) }

    let(:model) { create(:user, g5_access_token: g5_token) }
    before { model.password = model.password_confirmation = nil }

    context 'when there is a g5 token' do
      let(:g5_token) { 'my_g5_token' }

      it 'should reset the g5 token' do
        revoke_g5_credentials!
        expect(model.g5_access_token).to be_nil
      end

      it 'should save the changes' do
        revoke_g5_credentials!
        expect { model.reload }.to_not change { model.g5_access_token }
      end
    end

    context 'when there is no g5 token' do
      let(:g5_token) {}

      it 'should not set the g5 token' do
        revoke_g5_credentials!
        expect(model.g5_access_token).to be_nil
      end
    end
  end

  describe '#new_with_session' do
    subject(:new_with_session) { model_class.new_with_session(params, session) }

    let(:auth_data) do
      OmniAuth::AuthHash.new({
        provider: 'g5',
        uid: '123999',
        info: {name: 'Foo Bar',
               email: 'foo@bar.com'},
        credentials: {token: 'abc123'}
      })
    end

    context 'with params' do
      let(:params) { {'email' => email_param} }
      let(:email_param) { 'my.email.param@test.host' }

      context 'with session data' do
        let(:session) { {'omniauth.auth' => auth_data} }

        it { should be_new_record }
        its(:email) { should == email_param }
        its(:provider) { should == auth_data.provider }
        its(:uid) { should == auth_data.uid }
      end

      context 'without session data' do
        let(:session) { Hash.new }

        it { should be_new_record }
        its(:email) { should == email_param }
        its(:provider) { should be_nil }
        its(:uid) { should be_nil }
      end
    end

    context 'without params' do
      let(:params) { Hash.new }

      context 'with session data' do
        let(:session) { {'omniauth.auth' => auth_data} }

        it { should be_new_record }
        its(:email) { should == auth_data.info[:email] }
        its(:provider) { should == auth_data.provider }
        its(:uid) { should == auth_data.uid }
      end

      context 'without session data' do
        let(:session) { Hash.new }

        it { should be_new_record }
        its(:email) { should be_blank }
        its(:provider) { should be_nil }
        its(:uid) { should be_nil }
      end
    end
  end
end
