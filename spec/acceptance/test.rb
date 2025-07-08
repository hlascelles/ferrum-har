# frozen_string_literal: true

# With this ENV you can use the local checkout version of ferrum-har for testing
local_gem_test = ENV["FERRUM_HAR_TEST_LOCAL_GEM"] == "true"
ferrum_har_args = local_gem_test ? { path: File.expand_path("../../", __dir__) } : {}

# Use an inline gemfile for this script. This takes the place of a normal Gemfile.
require "bundler/inline"
gemfile do
  source "https://rubygems.org"
  gem "ferrum-har", ferrum_har_args
  gem "ferrum", "0.17.1"
  gem "pry-byebug"
end

# Install the Chrome binary if it is not already installed.
chrome_path = Ferrum::Har.find_chrome_for_testing_binary
Rake::Task["chrome:install"].invoke unless chrome_path
puts "Using Chrome binary at: #{Ferrum::Har.find_chrome_for_testing_binary}"

# Run the test
browser = Ferrum::Browser.new(
  headless: false,
  window_size: [1824, 768],
)
page = browser.create_page
page.go_to("https://www.bbc.com/")
page.network.wait_for_idle

# Returns the HAR as a JSON string
puts page.har
