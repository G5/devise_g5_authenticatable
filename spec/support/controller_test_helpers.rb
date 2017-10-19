# frozen_string_literal: true

module ControllerTestHelpers
  def build_params(hash)
    if Rails.version.starts_with?('4')
      hash
    else
      { params: hash }
    end
  end
end

RSpec.configure do |config|
  config.include ControllerTestHelpers, type: :controller
end
