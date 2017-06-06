# frozen_string_literal: true

require 'spec_helper'

describe DeviseG5Authenticatable::UrlHelpers do
  controller(ActionController::Base) do
    include DeviseG5Authenticatable::UrlHelpers
  end

  describe '#g5_authorize_path' do
    subject(:authorize_path) { controller.g5_authorize_path(resource_or_scope) }

    context 'with main_app router' do
      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(user_g5_authorize_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(admin_g5_authorize_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(user_g5_authorize_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(admin_g5_authorize_path) }
      end
    end

    context 'with custom router' do
      include_context 'custom router'
      before do
        allow(custom_router).to receive(:user_g5_authorize_path)
          .and_return('foo')
        allow(custom_router).to receive(:admin_g5_authorize_path)
          .and_return('bar')
      end

      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(custom_router.user_g5_authorize_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(custom_router.admin_g5_authorize_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(custom_router.user_g5_authorize_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(custom_router.admin_g5_authorize_path) }
      end
    end
  end

  describe '#g5_callback_path' do
    subject(:callback_path) { controller.g5_callback_path(resource_or_scope) }

    context 'with main_app router' do
      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(user_g5_callback_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(admin_g5_callback_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(user_g5_callback_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(admin_g5_callback_path) }
      end
    end

    context 'with custom router' do
      include_context 'custom router'
      before do
        allow(custom_router).to receive(:user_g5_callback_path)
          .and_return('foo_callback')
        allow(custom_router).to receive(:admin_g5_callback_path)
          .and_return('bar_callback')
      end

      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(custom_router.user_g5_callback_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(custom_router.admin_g5_callback_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(custom_router.user_g5_callback_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(custom_router.admin_g5_callback_path) }
      end
    end
  end

  describe '#new_session_path' do
    subject(:new_session_path) do
      controller.new_session_path(resource_or_scope)
    end

    context 'with main_app router' do
      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(new_user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(new_admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(new_user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(new_admin_session_path) }
      end
    end

    context 'with custom router' do
      include_context 'custom router'
      before do
        allow(custom_router).to receive(:new_user_session_path)
          .and_return('foo')
        allow(custom_router).to receive(:new_admin_session_path)
          .and_return('bar')
      end

      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(custom_router.new_user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(custom_router.new_admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(custom_router.new_user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(custom_router.new_admin_session_path) }
      end
    end
  end

  describe '#destroy_session_path' do
    subject(:destroy_session_path) do
      controller.destroy_session_path(resource_or_scope)
    end

    context 'with main_app router' do
      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(destroy_user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(destroy_admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(destroy_user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(destroy_admin_session_path) }
      end
    end

    context 'with custom router' do
      include_context 'custom router'
      before do
        allow(custom_router).to receive(:destroy_user_session_path)
          .and_return('foo')
        allow(custom_router).to receive(:destroy_admin_session_path)
          .and_return('bar')
      end

      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(custom_router.destroy_user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(custom_router.destroy_admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(custom_router.destroy_user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(custom_router.destroy_admin_session_path) }
      end
    end
  end

  describe '#session_path' do
    subject(:session_path) { controller.session_path(resource_or_scope) }

    context 'with main_app router' do
      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(admin_session_path) }
      end
    end

    context 'with custom router' do
      include_context 'custom router'

      before do
        allow(custom_router).to receive(:user_session_path).and_return('foo')
        allow(custom_router).to receive(:admin_session_path).and_return('bar')
      end

      context 'with user resource' do
        let(:resource_or_scope) { build_stubbed(:user) }

        it { is_expected.to eq(custom_router.user_session_path) }
      end

      context 'with admin resource' do
        let(:resource_or_scope) { build_stubbed(:admin) }

        it { is_expected.to eq(custom_router.admin_session_path) }
      end

      context 'with user scope' do
        let(:resource_or_scope) { :user }

        it { is_expected.to eq(custom_router.user_session_path) }
      end

      context 'with admin scope' do
        let(:resource_or_scope) { :admin }

        it { is_expected.to eq(custom_router.admin_session_path) }
      end
    end
  end
end
