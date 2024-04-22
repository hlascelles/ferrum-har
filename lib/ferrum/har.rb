# frozen_string_literal: true

require "ferrum"
require "ferrum/har/version"
require "ferrum/har/page_extension"

module Ferrum
  module Har
    GEM_DIR = File.expand_path("../..", __dir__)
    REQUIRED_BROWSER_OPTIONS = {
      "auto-open-devtools-for-tabs" => nil, # The chrome devtools must be open to invoke getHAR
      "load-extension" => "#{Ferrum::Har::GEM_DIR}/extension", # The extension that gets the HAR
    }.freeze
  end
end

# We have to remove the "disable-extensions" option from the default browser extension list because
# the ferrum-har gem requires an (internal) extension to work.
Ferrum::Browser::Options::Chrome::DEFAULT_OPTIONS =
  Ferrum::Browser::Options::Chrome::DEFAULT_OPTIONS.except("disable-extensions")

# Add the #har method to Ferrum::Page
Ferrum::Page.prepend(Ferrum::Har::PageExtension)
