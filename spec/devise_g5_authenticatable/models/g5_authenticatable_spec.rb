require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new(attributes) }
  let(:attributes) do
    {email: email,
     password: password}
  end

  let(:email) { 'test.email@test.host' }
  let(:password) { 'my_secret' }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }

  describe '#save!' do
    subject(:save_model) { model.save! }

    it 'should persist the email' do
      save_model
      expect(model_class.find(model.id).email).to eq(email)
    end

    it 'should not persist the password' do
      save_model
      expect(model_class.find(model.id).password).to be_nil
    end
  end
end
