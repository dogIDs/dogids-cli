# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codelation/version"

Gem::Specification.new do |spec|
  spec.name          = "codelation-cli"
  spec.version       = Codelation::VERSION
  spec.authors       = ["Brian Pattison"]
  spec.email         = ["brian@brianpattison.com"]
  spec.summary       = "Command line tool for Codelation tasks"
  spec.homepage      = "https://github.com/codelation/codelation-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "open_uri_redirections", "~> 0.2"
  spec.add_dependency "progressbar", "~> 0.21"
  spec.add_dependency "rubyzip", "~> 1.1"
  spec.add_dependency "thor", "~> 0.19"
end
