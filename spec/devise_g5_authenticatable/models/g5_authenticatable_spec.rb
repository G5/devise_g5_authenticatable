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
        model.updated_by = User.new
        save_model
        expect(model_class.find(model.id).updated_by).to be_nil
      end
    end
  end
end
