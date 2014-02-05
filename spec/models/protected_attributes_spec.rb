require 'spec_helper'

describe DeviseG5Authenticatable::Models::ProtectedAttributes do
  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:provider) }
  it { should allow_mass_assignment_of(:uid) }
  it { should_not allow_mass_assignment_of(:g5_access_token) }
  it { should allow_mass_assignment_of(:current_password) }
  it { should allow_mass_assignment_of(:updated_by) }
end
