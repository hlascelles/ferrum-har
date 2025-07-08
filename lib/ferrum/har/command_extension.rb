# frozen_string_literal: true

# This module is prepended to Ferrum::Browser::Command to check options required by ferrum-har
module Ferrum
  module Har
    class ConfigurationError < RuntimeError
    end

    class << self
      def find_chrome_for_testing_binary
        Dir.glob(".chrome-for-testing/**/chrome").max_by { |p| Gem::Version.new(p.split("/")[1]) }
      end
    end

    module BrowserCommandExtension
      def merge_options
        super.tap do |options|
          check_har_related_browser_options(options)
        end

        @path = ENV["BROWSER_PATH"] || Ferrum::Har.find_chrome_for_testing_binary

        return if @path

        raise <<~ERR
          Browser path not found. Please set BROWSER_PATH environment variable, or trigger a download of Chrome Testing by using:

          bundle exec rake chrome:install
        ERR
      end

      private def check_har_related_browser_options(options)
        options = options.transform_keys(&:to_s)

        check_disable_extensions_option(options)
        check_load_extension_option(options)
        check_auto_open_option(options)
        check_headless_option(options)
      end

      private def check_disable_extensions_option(options)
        disable_extensions_option_value = options.key?("disable-extensions")
        return unless disable_extensions_option_value

        raise Ferrum::Har::ConfigurationError, <<~MSG
          The ferrum-har gem requires the 'disable-extensions' browser option to be absent,
          ie: extensions should be allowed. The gem will do this for you automatically, but if you
          override the value, then ferrum-har will not work.

          It was found to be set to '#{disable_extensions_option_value}'.
        MSG
      end

      private def check_load_extension_option(options)
        load_extension_option_value = options["load-extension"]
        return unless load_extension_option_value != "#{Ferrum::Har::GEM_DIR}/extension"

        raise Ferrum::Har::ConfigurationError, <<~MSG
          The ferrum-har gem requires the 'load-extension' browser option to be set to
          '#{Ferrum::Har::GEM_DIR}/extension'. It will do this for you automatically, but if you
          override the value, then ferrum-har will not work.

          It was found to be set to '#{load_extension_option_value}'.
        MSG
      end

      private def check_auto_open_option(options)
        auto_open_value = options["auto-open-devtools-for-tabs"]
        return if auto_open_value.nil?

        raise Ferrum::Har::ConfigurationError, <<~MSG
          The ferrum-har gem requires the 'auto-open-devtools-for-tabs' browser option be enabled,
          '#{Ferrum::Har::GEM_DIR}/extension'. It will do this for you automatically, but if you
          override the value, then ferrum-har will not work.
          ie: set to nil.

          It was found to be set to '#{auto_open_value}'.
        MSG
      end

      private def check_headless_option(options)
        headless_value = options["headless"]
        return unless options.key?("headless") && [false, nil].include?(headless_value)

        raise Ferrum::Har::ConfigurationError, <<~MSG
          If you are using ferrum headless, the ferrum-har gem requires the browser
          option 'headless' to be set to 'new' instead of true or nil. Read this for more details:
          https://developer.chrome.com/docs/chromium/new-headless

          It was found to be set to '#{headless_value}'.
        MSG
      end
    end
  end
end
