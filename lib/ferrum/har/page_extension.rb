# frozen_string_literal: true

# This module is prepended to Ferrum::Page to add the #har method.
module Ferrum
  module Har
    module PageExtension
      class HarNotReadyError < RuntimeError
        # Used to loop until the HAR is ready.
      end

      # This method waits until the page is idle, then fetches the HAR and decodes it.
      def har
        network.wait_for_idle
        execute("document.ferrumHarRequested = true;")
        har_hash_result = Ferrum::Utils::Attempt.with_retry(
          errors: [HarNotReadyError],
          # 10 seconds
          max: 20,
          wait: 0.5
        ) do
          found = evaluate("document.ferrumHar;")
          raise HarNotReadyError unless found

          inlined_har = Base64.decode64(found)
          har_hash = JSON.parse(inlined_har)
          raise HarNotReadyError, "Result does not appear to be a HAR" unless har_hash.key?("log")

          entries = har_hash.dig("log", "entries")
          # If entries is nil or empty, the HAR is not ready yet.
          raise HarNotReadyError if entries.nil? || entries.empty?

          har_hash
        end

        JSON.pretty_generate(har_hash_result)
      end
    end
  end
end
