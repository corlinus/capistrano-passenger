# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "capistrano-passenger"
  spec.version       = '0.0.1'
  spec.authors       = ["corlinus"]
  spec.email         = ["corlinus@gmail.com\n"]
  spec.summary       = %q{passenger integration for capistrano}
  spec.description   = %q{passenger integration for capistrano}
  spec.homepage      = "http://github.com/corlinus/capistrano_passenger"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "capistrano", "~> 3.1"
end
