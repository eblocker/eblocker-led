# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eblocker/led/version'

Gem::Specification.new do |spec|
  spec.name          = "eblocker-led"
  spec.version       = Eblocker::Led::VERSION
  spec.authors       = ["eBlocker Open Source UG"]
  spec.email         = ["dev@eblocker.org"]
  spec.summary       = %q{eBlocker LED Controller}
  spec.description   = %q{(c) 2020 eBlocker Open Source UG, Hamburg, Germany}
  spec.homepage      = "https://github.com/eblocker/eblocker-led"
  spec.license       = "Proprietary"

  spec.files         = Dir['lib/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
