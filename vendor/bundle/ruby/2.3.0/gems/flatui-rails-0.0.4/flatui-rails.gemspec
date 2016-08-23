# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flatui/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "flatui-rails"
  spec.version       = Flatui::Rails::VERSION
  spec.authors       = ["Piotrek"]
  spec.email         = ["pkurek90@gmail.com"]
  spec.description   = %q{flat-ui for rails}
  spec.summary       = %q{flat-ui for rails using sass}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sass-rails", ">= 3.2.0"
  spec.add_dependency "railties", ">= 3.1"
  spec.add_dependency "bootstrap-sass", "2.2.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
