# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ferrum/har/version"

Gem::Specification.new do |spec|
  spec.name    = "ferrum-har"
  spec.version = Ferrum::Har::VERSION

  spec.authors       = ["Harry Lascelles"]
  spec.email         = ["harry@harrylascelles.com"]
  spec.summary       = "Rubygem to convert ferrum traffic to HAR files"
  spec.description   = "Rubygem to convert ferrum traffic to HAR files"
  spec.homepage      = "https://github.com/hlascelles/ferrum-har"
  spec.license       = "MIT"
  spec.metadata      = {
    "homepage_uri" => "https://github.com/hlascelles/ferrum-har",
    "documentation_uri" => "https://github.com/hlascelles/ferrum-har",
    "changelog_uri" => "https://github.com/hlascelles/ferrum-har/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/hlascelles/ferrum-har/",
    "bug_tracker_uri" => "https://github.com/hlascelles/ferrum-har/issues",
    "rubygems_mfa_required" => "true",
  }
  spec.required_ruby_version = ">= 3.0"

  spec.add_dependency "ferrum"
  spec.add_dependency "base64"

  spec.files = Dir["{bin,lib}/**/*"] + ["README.md"]
  spec.require_paths = ["lib"]
end
