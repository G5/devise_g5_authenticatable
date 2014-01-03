require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model) { User.new }

  it { should allow_mass_assignment_of(:email) }

  it 'should persist the email' do
    new_email = 'new.email@test.host'
    model.email = new_email
    model.save!
    model.reload
    expect(model.email).to eq(new_email)
  end
end
