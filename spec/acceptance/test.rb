# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "ferrum-har", path: File.expand_path("../../", __dir__)
end

require "ferrum/har"

browser = Ferrum::Browser.new(
  headless: false,
  window_size: [1824, 768],
)
page = browser.create_page
page.go_to("https://www.duckduckgo.com/")
page.network.wait_for_idle

# Returns the HAR as a JSON string
puts page.har
