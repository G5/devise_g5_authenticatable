# frozen_string_literal: true

RSpec.shared_context 'custom router' do
  before { Devise.router_name = :my_engine }
  after { Devise.router_name = nil }

  let(:custom_router) { double(:my_engine_router) }

  controller do
    def my_engine; end
  end

  before do
    allow(controller).to receive(:my_engine).and_return(custom_router)
  end
end
