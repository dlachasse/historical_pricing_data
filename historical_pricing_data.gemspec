# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'historical_pricing_data/version'
require 'dotenv'
Dotenv.load

Gem::Specification.new do |spec|
  spec.name          = 'historical_pricing_data'
  spec.version       = HistoricalPricingData::VERSION
  spec.authors       = ['David La Chasse']
  spec.email         = ['david.lachasse@gmail.com']
  spec.description   = %q{Pulls down pricing data from Amazon}
  spec.summary       = %q{Pulls down competitive pricing data from Amazon}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
