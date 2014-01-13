require 'spec_helper'

describe DeviseG5Authenticatable::UrlHelpers do
  controller(ActionController::Base) do
    include DeviseG5Authenticatable::UrlHelpers
  end

  describe '#g5_authorize_path' do
    subject(:authorize_path) { controller.g5_authorize_path(resource_or_scope) }

    context 'with user resource' do
      let(:resource_or_scope) { build_stubbed(:user) }

      it { should == user_g5_authorize_path }
    end

    context 'with admin resource' do
      let(:resource_or_scope) { build_stubbed(:admin) }

      it { should == admin_g5_authorize_path }
    end

    context 'with user scope' do
      let(:resource_or_scope) { :user }

      it { should == user_g5_authorize_path }
    end

    context 'with admin scope' do
      let(:resource_or_scope) { :admin }

      it { should == admin_g5_authorize_path }
    end
  end

  describe '#g5_callback_path' do
    subject(:callback_path) { controller.g5_callback_path(resource_or_scope) }

    context 'with user resource' do
      let(:resource_or_scope) { build_stubbed(:user) }

      it { should == user_g5_callback_path }
    end

    context 'with admin resource' do
      let(:resource_or_scope) { build_stubbed(:admin) }

      it { should == admin_g5_callback_path }
    end

    context 'with user scope' do
      let(:resource_or_scope) { :user }

      it { should == user_g5_callback_path }
    end

    context 'with admin scope' do
      let(:resource_or_scope) { :admin }

      it { should == admin_g5_callback_path }
    end
  end
end
