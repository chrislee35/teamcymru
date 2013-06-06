# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teamcymru/version'

Gem::Specification.new do |spec|
	spec.name          = "teamcymru"
	spec.version       = TeamCymru::VERSION
	spec.authors       = ["chrislee35"]
	spec.email         = ["rubygems@chrislee.dhs.org"]
	spec.description   = %q{Team Cymru provides a variety of services for network and security operators.  This Rubygem tries to wrap several of these services into a Ruby API.}
	spec.summary       = %q{Queries Team Cymru's ASN, Malware, and FullBogon services}
	spec.homepage      = "http://github.com/chrislee35/teamcymru"
	spec.license       = "MIT"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_runtime_dependency "structformatter", "~> 0.0.1"
	spec.add_runtime_dependency "twitter", "~> 4.7.0"
	spec.add_runtime_dependency "ruby-cache", ">= 0.3.0"
	spec.add_runtime_dependency "json", ">= 1.4.3"
	spec.add_runtime_dependency "configparser", "~> 0.1.1"
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake"

	spec.signing_key   = "#{File.dirname(__FILE__)}/../gem-private_key.pem"
	spec.cert_chain    = ["#{File.dirname(__FILE__)}/../gem-public_cert.pem"]
end
