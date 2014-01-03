require 'spec_helper'

describe Devise::Models::G5Authenticatable do
  subject { model }

  let(:model) { User.new }

  it 'should allow mass assignment of email' do
    expect(model).to allow_mass_assignment_of(:email)
  end
end
