# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'extended_email_reply_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "extended_email_reply_parser"
  spec.version       = ExtendedEmailReplyParser::VERSION
  spec.authors       = ["Sebastian Fiedlschuster"]
  spec.email         = ["sebastian@fiedlschuster.de"]

  spec.summary       = "This is an extended version of github's email_reply_parser."
  spec.description   = spec.description
  spec.homepage      = "https://github.com/fiedl/extended_email_reply_parser"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry'

  spec.add_dependency 'email_reply_parser', '~> 0.5.9'
  spec.add_dependency 'mail'
  spec.add_dependency 'charlock_holmes'
  spec.add_dependency 'activesupport'
end
