# frozen_string_literal: true

require "spec_helper"

describe Ferrum::Har do
  describe "#har" do
    it "fetches the HAR of a page" do
      browser = Ferrum::Browser.new(
        headless: ENV["CI"] == "true",
        window_size: [1824, 768],
      )
      page = browser.create_page
      page.go_to("https://bbc.com")
      page.network.wait_for_idle
      har = page.har
      File.write("target/example.har", har)
      page.screenshot(path: "target/screenshot.png")
      browser.quit
    end
  end
end
