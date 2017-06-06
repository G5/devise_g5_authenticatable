require 'spec_helper'

describe DeviseG5Authenticatable::Models::ProtectedAttributes do
  before do
    Dummy::Application.config.active_record.whitelist_attributes = true
  end

  after do
    Dummy::Application.config.active_record.whitelist_attributes = false
  end

  subject { model }

  let(:model_class) { User }
  let(:model) { model_class.new }

  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:password) }
  it { is_expected.to allow_mass_assignment_of(:password_confirmation) }
  it { is_expected.to allow_mass_assignment_of(:provider) }
  it { is_expected.to allow_mass_assignment_of(:uid) }
  it { is_expected.not_to allow_mass_assignment_of(:g5_access_token) }
  it { is_expected.to allow_mass_assignment_of(:current_password) }
  it { is_expected.to allow_mass_assignment_of(:updated_by) }
end
