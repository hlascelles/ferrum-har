# frozen_string_literal: true

# This module is prepended to Ferrum::Browser::Options::Chrome to alter the default options so they
# work with the ferrum-har gem.
module Ferrum
  module Har
    module OptionsExtension
      def merge_default(flags, options)
        original_result = super
        # We have to remove the "disable-extensions" option from the default browser extension
        # list because the ferrum-har gem requires an (internal) extension to work.
        changed =
          original_result
          .except("disable-extensions")
          # At some point past v134 this stopped extensions loading properly in the first tab.
          .except("no-startup-window")
          .merge(
            "auto-open-devtools-for-tabs" => nil, # Chrome devtools must be open to invoke getHAR
            "load-extension" => "#{Ferrum::Har::GEM_DIR}/extension", # Extension that gets the HAR
          )

        # To get a custom config dir to work, we have to remove the "disable-web-security" option
        if ENV["FERRUM_HAR_BROWSER_CONFIG_DIR"]
          changed =
            changed
            .except("disable-web-security")
            .merge("user-data-dir" => ENV["FERRUM_HAR_BROWSER_CONFIG_DIR"])
        end

        changed
      end
    end
  end
end
