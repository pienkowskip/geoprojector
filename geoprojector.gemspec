# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_projector/version'

Gem::Specification.new do |spec|
  spec.name          = 'geoprojector'
  spec.version       = GeoProjector::VERSION
  spec.authors       = ['Paweł Peńkowski']
  spec.email         = ['pienkowskip@gmail.com']
  spec.description   = ''
  spec.summary       = ''
  spec.homepage      = 'https://github.com/pienkowskip/geoprojector'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'geoutm'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry'
end
