# frozen_string_literal: true

require "ferrum/har"

browser = Ferrum::Browser.new(
  headless: false,
)
page = browser.create_page
page.go_to("https://www.bbc.co.uk")

# Returns the HAR as a JSON string
puts page.har
