# frozen_string_literal: true

require "spec_helper"

describe Ferrum::Har do
  describe "#har" do
    it "checks the options" do
      expect {
        Ferrum::Browser.new(
          browser_options: {
            "disable-extensions": nil,
          }
        )
      }.to raise_error(Ferrum::Har::ConfigurationError)
    end

    if ENV["CI"] != "true"
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

        JSON.parse(har).tap do |har_hash|
          expect(har_hash).to be_a(Hash)
          expect(har_hash["log"]).to be_a(Hash)
          expect(har_hash["log"]["entries"].size).not_to be_empty
        end
      end
    end
  end
end
