# frozen_string_literal: true

module ControllerTestHelpers
  def build_params(hash)
    Rails.version.starts_with?('5') ? { params: hash } : hash
  end
end

RSpec.configure do |config|
  config.include ControllerTestHelpers, type: :controller
end
