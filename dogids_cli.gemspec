# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dogids/version"

Gem::Specification.new do |spec|
  spec.name          = "dogids-cli"
  spec.version       = Dogids::VERSION
  spec.authors       = ["Brian Pattison"]
  spec.email         = ["brian@brianpattison.com"]
  spec.summary       = "Command line tool for dogIDs tasks"
  spec.homepage      = "https://github.com/dogIDs/dogids-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ssh", "~> 2.9"
  spec.add_dependency "thor", "~> 0.19"
end
