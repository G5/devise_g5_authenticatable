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
    subject(:save_model) { model.save! }

    let(:attributes) do
      {email: email,
      password: password,
      password_confirmation: password_confirmation,
      current_password: current_password,
      updated_by: updated_by}
    end

    let(:email) { 'test.email@test.host' }
    let(:password) { 'my_secret' }
    let(:password_confirmation) { password }
    let(:current_password) { 'my_current_password' }
    let(:updated_by) { User.new }

    context 'when model is valid' do
      it 'should persist the email' do
        save_model
        expect(model_class.find(model.id).email).to eq(email)
      end

      it 'should not persist the password' do
        save_model
        expect(model_class.find(model.id).password).to be_nil
      end

      it 'should not persist the password_confirmation' do
        save_model
        expect(model_class.find(model.id).password_confirmation).to be_nil
      end

      it 'should not persist the current_password' do
        save_model
        expect(model_class.find(model.id).current_password).to be_nil
      end

      it 'should not persist updated by' do
        save_model
        expect(model_class.find(model.id).updated_by).to be_nil
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
      allow(AuthPasswordValidator).to receive(:new).
        and_return(password_validator)
    end

    context 'with valid current password' do
      before { allow(password_validator).to receive(:valid_password?).and_return(true) }

      context 'with updated password' do
        context 'with valid input' do
          it 'should return true' do
            expect(update_with_password).to be_true
          end

          it 'should clear the user password' do
            expect { update_with_password }.to change { model.password }.to(nil)
          end

          it 'should clear the user password_confirmation' do
            expect { update_with_password }.to change { model.password_confirmation }.to(nil)
          end

          it 'should update the credentials in the auth server' do
            expect(auth_updater).to receive(:update).with(model)
            update_with_password
          end

          it 'should update the email on the local model' do
            expect { update_with_password }.to change { model.email }.to(updated_email)
          end
        end

        context 'with invalid email' do
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

      context 'without updated password' do
        let(:updated_password) { '' }
        before { model.clean_up_passwords }

        context 'with updated email' do
          it 'should return true' do
            expect(update_with_password).to be_true
          end

          it 'should update the credentials on the auth server' do
            expect(auth_updater).to receive(:update).with(model)
            update_with_password
          end

          it 'should update the email on the local model' do
            expect { update_with_password }.to change { model.email }.to(updated_email)
          end
        end

        context 'with unchanged email' do
          let(:updated_email) { model.email }

          it 'should return true' do
            expect(update_with_password).to be_true
          end

          it 'should not update the credentials in the auth server' do
            expect(auth_updater).to_not receive(:update)
            update_with_password
          end
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
end
