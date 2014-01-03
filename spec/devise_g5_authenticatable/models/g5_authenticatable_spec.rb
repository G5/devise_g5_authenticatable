require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new(attributes) }
  let(:attributes) do
    {email: email,
     password: password,
     password_confirmation: password_confirmation}
  end

  let(:email) { 'test.email@test.host' }
  let(:password) { 'my_secret' }
  let(:password_confirmation) { password }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }

  describe '#save!' do
    subject(:save_model) { model.save! }

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
    end
  end
end
