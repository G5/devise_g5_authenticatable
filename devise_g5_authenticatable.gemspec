# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_g5_authenticatable/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise_g5_authenticatable'
  spec.version       = DeviseG5Authenticatable::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Maeve Revels']
  spec.email         = ['maeve.revels@getg5.com']
  spec.description   = 'Devise extension for the G5 Auth service'
  spec.summary       = 'Devise extension for the G5 Auth service'
  spec.homepage      = 'https://github.com/G5/devise_g5_authenticatable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'devise', '~> 4.3'
  spec.add_dependency 'g5_authentication_client', '~> 1.0'

  # Pinned to version 0.3.1 due https://github.com/G5/omniauth-g5/pull/10
  # Omniauth-auth2 removed 'callback_url' which broke our auth workflow
  spec.add_dependency 'omniauth-g5', '= 0.3.1'
end
