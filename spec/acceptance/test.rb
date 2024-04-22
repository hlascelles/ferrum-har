# frozen_string_literal: true

require "ferrum/har"

browser = Ferrum::Browser.new(
  headless: false,
  window_size: [1824, 768],
)
page = browser.create_page
page.go_to("https://www.bbc.co.uk")
page.network.wait_for_idle

# Returns the HAR as a JSON string
puts page.har
