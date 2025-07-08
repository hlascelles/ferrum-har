# frozen_string_literal: true

require "ferrum"
require "ferrum/browser/options/chrome"
require "ferrum/har/version"
require "ferrum/har/command_extension"
require "ferrum/har/page_extension"
require "ferrum/har/options_extension"

# The chrome downloader helper
if Gem.loaded_specs.key?("rake")
  require "selenium_chrome_helper"
  require "rake"
  load "tasks/install.rake" # Load the chrome testing downloader task
end

module Ferrum
  module Har
    GEM_DIR = File.expand_path("../..", __dir__)
  end
end

# Add the #har method to Ferrum::Page
Ferrum::Page.prepend(Ferrum::Har::PageExtension)

# Add the #merge_default method to Ferrum::Browser::Options::Chrome
Ferrum::Browser::Options::Chrome.prepend(Ferrum::Har::OptionsExtension)

# Add the #check_har_related_browser_options method to Ferrum::Browser::Command
Ferrum::Browser::Command.prepend(Ferrum::Har::BrowserCommandExtension)
