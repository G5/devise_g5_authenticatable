# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_g5_authenticatable/version'

Gem::Specification.new do |spec|
  spec.name          = "devise_g5_authenticatable"
  spec.version       = DeviseG5Authenticatable::VERSION
  spec.authors       = ["maeve"]
  spec.email         = ["maeve.revels@getg5.com"]
  spec.description   = %q{Devise extension for G5 authentication service}
  spec.summary       = %q{Extension to devise that adds support for authenticating
                          to G5 via OAuth 2.0, as well as remotely managing
                          credentials in G5's authentication API.}
  spec.homepage      = "https://github.com/g5search/devise_g5_authenticatable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
