lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cancando/version'

Gem::Specification.new do |spec|
  spec.name          = 'cancando'
  spec.version       = Cancando::VERSION
  spec.authors       = ['Viktor Markov']
  spec.email         = ['viktormarkov25@gmail.com']

  spec.summary       = 'Increase accessible_by query performance via ability merging'
  spec.description   = 'Helper for Cancancan. Increase accessible_by query performance via ability merging'
  spec.homepage      = 'https://github.com/viktormarkov/cancando'
  spec.license       = 'MIT'
  spec.platform      = Gem::Platform::RUBY

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'cancancan', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
