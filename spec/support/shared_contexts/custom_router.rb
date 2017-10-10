# frozen_string_literal: true

RSpec.shared_context 'custom router' do
  before do
    unless Devise.respond_to?(:router_name)
      skip 'This version of devise does not support custom routers'
    end
  end

  before { Devise.router_name = :my_engine }
  after { Devise.router_name = nil if Devise.respond_to?(:router_name=) }

  let(:custom_router) { double(:my_engine_router) }

  controller do
    def my_engine; end
  end

  before do
    allow(controller).to receive(:my_engine).and_return(custom_router)
  end
end

RSpec.configure do |config|
  config.before(:example, custom_router: true) do
    skip 'This version of Devise does not support custom routers' unless Devise.respond_to?(:router_name)
  end
end
